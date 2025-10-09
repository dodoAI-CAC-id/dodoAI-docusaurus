import { Project, Task, Template, Category } from '../entities/Project'

export interface CreateProjectInput {
  name: string
  description?: string
}

export interface CreateTaskInput {
  name: string
  category: Category
  projectId: string
}

export interface CreateTemplateInput {
  name: string
  content: string
  taskId: string
}

export interface TemplateRepository {
  getProjects(): Promise<Project[]>
  getProject(id: string): Promise<Project | null>
  createProject(input: CreateProjectInput): Promise<Project>
  
  getTasks(projectId?: string, category?: Category): Promise<Task[]>
  createTask(input: CreateTaskInput): Promise<Task>
  
  getTemplates(taskId?: string, search?: string): Promise<Template[]>
  searchTemplates(keyword: string, category?: Category, projectId?: string): Promise<Template[]>
  createTemplate(input: CreateTemplateInput): Promise<Template>
  deleteTemplate(id: string): Promise<boolean>
}
