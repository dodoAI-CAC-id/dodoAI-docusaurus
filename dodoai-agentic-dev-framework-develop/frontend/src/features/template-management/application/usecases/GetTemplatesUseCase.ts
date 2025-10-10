import { TemplateRepository } from '../../domain/repositories/TemplateRepository'
import { Template, Category } from '../../domain/entities/Project'

export class GetTemplatesUseCase {
  constructor(private templateRepository: TemplateRepository) {}

  async execute(filters?: {
    taskId?: string
    search?: string
    keyword?: string
    category?: Category
    projectId?: string
  }): Promise<Template[]> {
    if (filters?.keyword) {
      return this.templateRepository.searchTemplates(
        filters.keyword,
        filters.category,
        filters.projectId
      )
    }

    return this.templateRepository.getTemplates(filters?.taskId, filters?.search)
  }
}
