import { TemplateRepository, CreateTemplateInput } from '../../domain/repositories/TemplateRepository'
import { Template } from '../../domain/entities/Project'

export class CreateTemplateUseCase {
  constructor(private templateRepository: TemplateRepository) {}

  async execute(input: CreateTemplateInput): Promise<Template> {
    if (!input.name.trim()) {
      throw new Error('Template name is required')
    }

    if (!input.content.trim()) {
      throw new Error('Template content is required')
    }

    return this.templateRepository.createTemplate(input)
  }
}
