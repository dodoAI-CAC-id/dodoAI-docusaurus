import { ApolloClient } from '@apollo/client'
import { TemplateRepository, CreateProjectInput, CreateTaskInput, CreateTemplateInput } from '../../domain/repositories/TemplateRepository'
import { Project, Task, Template, Category } from '../../domain/entities/Project'
import {
  GET_PROJECTS,
  GET_TASKS,
  GET_TEMPLATES,
  SEARCH_TEMPLATES,
  CREATE_PROJECT,
  CREATE_TASK,
  CREATE_TEMPLATE,
  DELETE_TEMPLATE,
} from '../graphql/queries'

export class GraphQLTemplateRepository implements TemplateRepository {
  constructor(private apolloClient: ApolloClient<any>) {}

  async getProjects(): Promise<Project[]> {
    const { data } = await this.apolloClient.query({
      query: GET_PROJECTS,
    })
    return data.projects
  }

  async getProject(id: string): Promise<Project | null> {
    const projects = await this.getProjects()
    return projects.find(p => p.id === id) || null
  }

  async createProject(input: CreateProjectInput): Promise<Project> {
    const { data } = await this.apolloClient.mutate({
      mutation: CREATE_PROJECT,
      variables: { input },
      refetchQueries: [{ query: GET_PROJECTS }],
    })
    return data.createProject
  }

  async getTasks(projectId?: string, category?: Category): Promise<Task[]> {
    const { data } = await this.apolloClient.query({
      query: GET_TASKS,
      variables: { projectId, category },
    })
    return data.tasks
  }

  async createTask(input: CreateTaskInput): Promise<Task> {
    const { data } = await this.apolloClient.mutate({
      mutation: CREATE_TASK,
      variables: { input },
      refetchQueries: [{ query: GET_TASKS }],
    })
    return data.createTask
  }

  async getTemplates(taskId?: string, search?: string): Promise<Template[]> {
    const { data } = await this.apolloClient.query({
      query: GET_TEMPLATES,
      variables: { taskId, search },
    })
    return data.templates
  }

  async searchTemplates(keyword: string, category?: Category, projectId?: string): Promise<Template[]> {
    const { data } = await this.apolloClient.query({
      query: SEARCH_TEMPLATES,
      variables: { keyword, category, projectId },
    })
    return data.searchTemplates
  }

  async createTemplate(input: CreateTemplateInput): Promise<Template> {
    const { data } = await this.apolloClient.mutate({
      mutation: CREATE_TEMPLATE,
      variables: { input },
      refetchQueries: [{ query: GET_TEMPLATES }],
    })
    return data.createTemplate
  }

  async deleteTemplate(id: string): Promise<boolean> {
    const { data } = await this.apolloClient.mutate({
      mutation: DELETE_TEMPLATE,
      variables: { id },
      refetchQueries: [{ query: GET_TEMPLATES }],
    })
    return data.deleteTemplate
  }
}
