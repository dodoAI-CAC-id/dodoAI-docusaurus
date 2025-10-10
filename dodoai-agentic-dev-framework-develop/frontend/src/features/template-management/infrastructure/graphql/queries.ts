import { gql } from '@apollo/client'

export const GET_PROJECTS = gql`
  query GetProjects {
    projects {
      id
      name
      description
      createdAt
      updatedAt
      tasks {
        id
        name
        category
        createdAt
        updatedAt
      }
    }
  }
`

export const GET_TASKS = gql`
  query GetTasks($projectId: ID, $category: Category) {
    tasks(projectId: $projectId, category: $category) {
      id
      name
      category
      createdAt
      updatedAt
      project {
        id
        name
      }
      templates {
        id
        name
        content
        createdAt
        updatedAt
      }
    }
  }
`

export const GET_TEMPLATES = gql`
  query GetTemplates($taskId: ID, $search: String) {
    templates(taskId: $taskId, search: $search) {
      id
      name
      content
      createdAt
      updatedAt
      task {
        id
        name
        category
        project {
          id
          name
        }
      }
    }
  }
`

export const SEARCH_TEMPLATES = gql`
  query SearchTemplates($keyword: String!, $category: Category, $projectId: ID) {
    searchTemplates(keyword: $keyword, category: $category, projectId: $projectId) {
      id
      name
      content
      createdAt
      updatedAt
      task {
        id
        name
        category
        project {
          id
          name
        }
      }
    }
  }
`

export const CREATE_PROJECT = gql`
  mutation CreateProject($input: ProjectInput!) {
    createProject(input: $input) {
      id
      name
      description
      createdAt
      updatedAt
    }
  }
`

export const CREATE_TASK = gql`
  mutation CreateTask($input: TaskInput!) {
    createTask(input: $input) {
      id
      name
      category
      createdAt
      updatedAt
      project {
        id
        name
      }
    }
  }
`

export const CREATE_TEMPLATE = gql`
  mutation CreateTemplate($input: TemplateInput!) {
    createTemplate(input: $input) {
      id
      name
      content
      createdAt
      updatedAt
      task {
        id
        name
        category
        project {
          id
          name
        }
      }
    }
  }
`

export const DELETE_TEMPLATE = gql`
  mutation DeleteTemplate($id: ID!) {
    deleteTemplate(id: $id)
  }
`

export const GET_GRAPH_DATA = gql`
  query GetGraphData {
    projects {
      id
      name
      description
      tasks {
        id
        name
        category
        templates {
          id
          name
        }
      }
    }
  }
`
