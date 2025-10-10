import React from 'react'
import { Template } from '@/features/template-management/domain/entities/Project'
import { Text } from '../atoms/Text'
import { Button } from '../atoms/Button'
import { format } from 'date-fns'

interface TemplateCardProps {
  template: Template
  onEdit?: (template: Template) => void
  onDelete?: (template: Template) => void
}

export function TemplateCard({ template, onEdit, onDelete }: TemplateCardProps) {
  return (
    <div className="bg-white rounded-lg shadow-sm border border-gray-200 p-4 hover:shadow-md transition-shadow">
      <div className="flex justify-between items-start mb-2">
        <Text variant="h3" className="text-lg">{template.name}</Text>
        <div className="flex gap-2">
          {onEdit && (
            <Button size="sm" variant="secondary" onClick={() => onEdit(template)}>
              Edit
            </Button>
          )}
          {onDelete && (
            <Button size="sm" variant="danger" onClick={() => onDelete(template)}>
              Delete
            </Button>
          )}
        </div>
      </div>
      
      <div className="mb-3">
        <Text variant="caption">
          {template.task.project.name} • {template.task.name} • {template.task.category}
        </Text>
      </div>
      
      <div className="mb-3">
        <Text variant="body" className="line-clamp-3">
          {template.content.substring(0, 150)}
          {template.content.length > 150 && '...'}
        </Text>
      </div>
      
      <div className="text-xs text-gray-400">
        Updated {format(new Date(template.updatedAt), 'MMM d, yyyy')}
      </div>
    </div>
  )
}
