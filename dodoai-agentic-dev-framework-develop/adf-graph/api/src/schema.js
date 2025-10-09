const { gql } = require('apollo-server-express');

const typeDefs = gql`
  scalar DateTime

  enum Category {
    DESIGN
    API
    FRONTEND
    SMARTCONTRACT
    OTHER
  }

  type Project {
    id: ID!
    name: String!
    description: String
    createdAt: DateTime!
    updatedAt: DateTime!
    tasks: [Task!]!
  }

  type Task {
    id: ID!
    name: String!
    category: Category!
    project: Project!
    templates: [Template!]!
    createdAt: DateTime!
    updatedAt: DateTime!
  }

  type Template {
    id: ID!
    name: String!
    content: String!
    task: Task!
    createdAt: DateTime!
    updatedAt: DateTime!
  }

  input ProjectInput {
    name: String!
    description: String
  }

  input TaskInput {
    name: String!
    category: Category!
    projectId: ID!
  }

  input TemplateInput {
    name: String!
    content: String!
    taskId: ID!
  }

  type Query {
    projects: [Project!]!
    project(id: ID!): Project
    tasks(projectId: ID, category: Category): [Task!]!
    task(id: ID!): Task
    templates(taskId: ID, search: String): [Template!]!
    template(id: ID!): Template
    searchTemplates(keyword: String!, category: Category, projectId: ID): [Template!]!
  }

  type Mutation {
    createProject(input: ProjectInput!): Project!
    updateProject(id: ID!, input: ProjectInput!): Project!
    deleteProject(id: ID!): Boolean!
    
    createTask(input: TaskInput!): Task!
    updateTask(id: ID!, input: TaskInput!): Task!
    deleteTask(id: ID!): Boolean!
    
    createTemplate(input: TemplateInput!): Template!
    updateTemplate(id: ID!, input: TemplateInput!): Template!
    deleteTemplate(id: ID!): Boolean!
  }
`;

module.exports = typeDefs;
