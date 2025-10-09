import React from 'react'
import { Template } from '@/features/template-management/domain/entities/Project'
import { TemplateCard } from '../molecules/TemplateCard'
import { Text } from '../atoms/Text'

interface TemplateListProps {
  templates: Template[]
  loading?: boolean
  onEdit?: (template: Template) => void
  onDelete?: (template: Template) => void
}

export function TemplateList({ templates, loading, onEdit, onDelete }: TemplateListProps) {
  if (loading) {
    return (
      <div className="flex justify-center items-center py-8">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600"></div>
      </div>
    )
  }

  if (templates.length === 0) {
    return (
      <div className="text-center py-8">
        <Text variant="body" className="text-gray-500">
          No templates found. Create your first template to get started.
        </Text>
      </div>
    )
  }

  return (
    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
      {templates.map((template) => (
        <TemplateCard
          key={template.id}
          template={template}
          onEdit={onEdit}
          onDelete={onDelete}
        />
      ))}
    </div>
  )
}
