export interface Project {
  id: string
  name: string
  description?: string
  createdAt: string
  updatedAt: string
  tasks: Task[]
}

export interface Task {
  id: string
  name: string
  category: Category
  project: Project
  templates: Template[]
  createdAt: string
  updatedAt: string
}

export interface Template {
  id: string
  name: string
  content: string
  task: Task
  createdAt: string
  updatedAt: string
}

export enum Category {
  DESIGN = 'DESIGN',
  API = 'API',
  FRONTEND = 'FRONTEND',
  SMARTCONTRACT = 'SMARTCONTRACT',
  OTHER = 'OTHER',
}
