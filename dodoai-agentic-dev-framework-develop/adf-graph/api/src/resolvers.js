const { GraphQLScalarType } = require('graphql');
const { Kind } = require('graphql/language');

const DateTimeType = new GraphQLScalarType({
  name: 'DateTime',
  serialize: (value) => value.toISOString(),
  parseValue: (value) => new Date(value),
  parseLiteral: (ast) => {
    if (ast.kind === Kind.STRING) {
      return new Date(ast.value);
    }
    return null;
  },
});

const resolvers = {
  DateTime: DateTimeType,

  Project: {
    id: (parent) => parent.uid,
    tasks: async (parent, _, { dgraphClient }) => {
      const query = `{
        tasks(func: type(Task)) @filter(uid_in(project, ${parent.uid})) {
          uid
          name
          category
          createdAt
          updatedAt
          templates {
            uid
            name
            content
            createdAt
            updatedAt
          }
        }
      }`;
      
      const txn = dgraphClient.newTxn({ readOnly: true });
      try {
        const res = await txn.query(query);
        return res.getJson().tasks || [];
      } finally {
        await txn.discard();
      }
    },
  },

  Task: {
    id: (parent) => parent.uid,
    project: async (parent, _, { dgraphClient }) => {
      if (parent.project && parent.project.uid) {
        return parent.project;
      }
      
      const query = `{
        task(func: uid(${parent.uid})) {
          project {
            uid
            name
            description
            createdAt
            updatedAt
          }
        }
      }`;
      
      const txn = dgraphClient.newTxn({ readOnly: true });
      try {
        const res = await txn.query(query);
        const task = res.getJson().task[0];
        return task ? task.project : null;
      } finally {
        await txn.discard();
      }
    },
    templates: async (parent, _, { dgraphClient }) => {
      if (parent.templates) {
        return parent.templates;
      }
      
      const query = `{
        templates(func: type(Template)) @filter(uid_in(task, ${parent.uid})) {
          uid
          name
          content
          createdAt
          updatedAt
        }
      }`;
      
      const txn = dgraphClient.newTxn({ readOnly: true });
      try {
        const res = await txn.query(query);
        return res.getJson().templates || [];
      } finally {
        await txn.discard();
      }
    },
  },

  Template: {
    id: (parent) => parent.uid,
    task: async (parent, _, { dgraphClient }) => {
      if (parent.task && parent.task.uid) {
        return parent.task;
      }
      
      const query = `{
        template(func: uid(${parent.uid})) {
          task {
            uid
            name
            category
            createdAt
            updatedAt
            project {
              uid
              name
              description
              createdAt
              updatedAt
            }
          }
        }
      }`;
      
      const txn = dgraphClient.newTxn({ readOnly: true });
      try {
        const res = await txn.query(query);
        const template = res.getJson().template[0];
        return template ? template.task : null;
      } finally {
        await txn.discard();
      }
    },
  },

  Query: {
    projects: async (_, __, { dgraphClient }) => {
      const query = `
        query {
          projects(func: type(Project)) {
            uid
            name
            description
            createdAt
            updatedAt
            tasks {
              uid
              name
              category
              createdAt
              updatedAt
            }
          }
        }
      `;
      
      const txn = dgraphClient.newTxn({ readOnly: true });
      try {
        const res = await txn.query(query);
        return res.getJson().projects || [];
      } finally {
        await txn.discard();
      }
    },

    project: async (_, { id }, { dgraphClient }) => {
      const query = `
        query getProject($id: string) {
          project(func: uid($id)) @filter(type(Project)) {
            uid
            name
            description
            createdAt
            updatedAt
            tasks {
              uid
              name
              category
              createdAt
              updatedAt
            }
          }
        }
      `;
      
      const txn = dgraphClient.newTxn({ readOnly: true });
      try {
        const res = await txn.query(query, { $id: id });
        const projects = res.getJson().project || [];
        return projects[0] || null;
      } finally {
        await txn.discard();
      }
    },

    tasks: async (_, { projectId, category }, { dgraphClient }) => {
      let query = `
        query getTasks($projectId: string, $category: string) {
          tasks(func: type(Task)) 
      `;
      
      const filters = [];
      if (projectId) filters.push('@filter(uid_in(project, $projectId))');
      if (category) filters.push('@filter(eq(category, $category))');
      
      if (filters.length > 0) {
        query += filters.join(' AND ');
      }
      
      query += ` {
            uid
            name
            category
            createdAt
            updatedAt
            project {
              uid
              name
            }
            templates {
              uid
              name
              content
              createdAt
              updatedAt
            }
          }
        }
      `;
      
      const txn = dgraphClient.newTxn({ readOnly: true });
      try {
        const res = await txn.query(query, { $projectId: projectId, $category: category });
        return res.getJson().tasks || [];
      } finally {
        await txn.discard();
      }
    },

    templates: async (_, { taskId, search }, { dgraphClient }) => {
      let query = `
        query getTemplates($taskId: string, $search: string) {
          templates(func: type(Template))
      `;
      
      const filters = [];
      if (taskId) filters.push('@filter(uid_in(task, $taskId))');
      if (search) filters.push('@filter(alloftext(name, $search) OR alloftext(content, $search))');
      
      if (filters.length > 0) {
        query += filters.join(' AND ');
      }
      
      query += ` {
            uid
            name
            content
            createdAt
            updatedAt
            task {
              uid
              name
              category
              project {
                uid
                name
              }
            }
          }
        }
      `;
      
      const txn = dgraphClient.newTxn({ readOnly: true });
      try {
        const res = await txn.query(query, { $taskId: taskId, $search: search });
        return res.getJson().templates || [];
      } finally {
        await txn.discard();
      }
    },

    searchTemplates: async (_, { keyword, category, projectId }, { dgraphClient }) => {
      let query = `
        query searchTemplates($keyword: string, $category: string, $projectId: string) {
          templates(func: type(Template)) @filter(alloftext(name, $keyword) OR alloftext(content, $keyword))
      `;
      
      if (category || projectId) {
        query += ` @filter(`;
        const filters = [];
        if (category) filters.push('eq(task.category, $category)');
        if (projectId) filters.push('uid_in(task.project, $projectId)');
        query += filters.join(' AND ') + ')';
      }
      
      query += ` {
            uid
            name
            content
            createdAt
            updatedAt
            task {
              uid
              name
              category
              project {
                uid
                name
              }
            }
          }
        }
      `;
      
      const txn = dgraphClient.newTxn({ readOnly: true });
      try {
        const res = await txn.query(query, { $keyword: keyword, $category: category, $projectId: projectId });
        return res.getJson().templates || [];
      } finally {
        await txn.discard();
      }
    },
  },

  Mutation: {
    createProject: async (_, { input }, { dgraphClient }) => {
      const now = new Date().toISOString();
      const mutation = {
        uid: '_:project',
        'dgraph.type': 'Project',
        name: input.name,
        description: input.description || '',
        createdAt: now,
        updatedAt: now,
      };

      const txn = dgraphClient.newTxn();
      try {
        const assigned = await txn.mutate({ setJson: mutation });
        await txn.commit();
        
        return {
          id: assigned.getUidsMap().get('project'),
          ...input,
          createdAt: now,
          updatedAt: now,
          tasks: [],
        };
      } finally {
        await txn.discard();
      }
    },

    createTask: async (_, { input }, { dgraphClient }) => {
      const now = new Date().toISOString();
      const mutation = {
        uid: '_:task',
        'dgraph.type': 'Task',
        name: input.name,
        category: input.category,
        project: { uid: input.projectId },
        createdAt: now,
        updatedAt: now,
      };

      const txn = dgraphClient.newTxn();
      try {
        const assigned = await txn.mutate({ setJson: mutation });
        await txn.commit();
        
        return {
          id: assigned.getUidsMap().get('task'),
          ...input,
          createdAt: now,
          updatedAt: now,
          templates: [],
        };
      } finally {
        await txn.discard();
      }
    },

    createTemplate: async (_, { input }, { dgraphClient }) => {
      const now = new Date().toISOString();
      const mutation = {
        uid: '_:template',
        'dgraph.type': 'Template',
        name: input.name,
        content: input.content,
        task: { uid: input.taskId },
        createdAt: now,
        updatedAt: now,
      };

      const txn = dgraphClient.newTxn();
      try {
        const assigned = await txn.mutate({ setJson: mutation });
        await txn.commit();
        
        return {
          id: assigned.getUidsMap().get('template'),
          ...input,
          createdAt: now,
          updatedAt: now,
        };
      } finally {
        await txn.discard();
      }
    },

    deleteTemplate: async (_, { id }, { dgraphClient }) => {
      const mutation = {
        uid: id,
        'dgraph.type': null,
      };

      const txn = dgraphClient.newTxn();
      try {
        await txn.mutate({ deleteJson: mutation });
        await txn.commit();
        return true;
      } catch (error) {
        console.error('Error deleting template:', error);
        return false;
      } finally {
        await txn.discard();
      }
    },
  },
};

module.exports = resolvers;
