import React, { useState } from 'react'
import { Category } from '@/features/template-management/domain/entities/Project'
import { Input } from '../atoms/Input'
import { Select } from '../atoms/Select'
import { Button } from '../atoms/Button'
import { Text } from '../atoms/Text'

interface TemplateFormProps {
  onSubmit: (data: {
    name: string
    content: string
    taskName: string
    category: Category
    projectName: string
  }) => void
  onCancel: () => void
  loading?: boolean
}

export function TemplateForm({ onSubmit, onCancel, loading }: TemplateFormProps) {
  const [formData, setFormData] = useState({
    name: '',
    content: '',
    taskName: '',
    category: Category.OTHER,
    projectName: '',
  })

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault()
    onSubmit(formData)
  }

  const handleChange = (field: string, value: string | Category) => {
    setFormData(prev => ({ ...prev, [field]: value }))
  }

  return (
    <div className="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
      <Text variant="h2" className="mb-6">Add New Template</Text>
      
      <form onSubmit={handleSubmit} className="space-y-4">
        <Input
          label="Project Name"
          value={formData.projectName}
          onChange={(e) => handleChange('projectName', e.target.value)}
          required
        />
        
        <Input
          label="Task Name"
          value={formData.taskName}
          onChange={(e) => handleChange('taskName', e.target.value)}
          required
        />
        
        <Select
          label="Category"
          value={formData.category}
          onChange={(e) => handleChange('category', e.target.value as Category)}
          required
        >
          <option value={Category.DESIGN}>Design</option>
          <option value={Category.API}>API</option>
          <option value={Category.FRONTEND}>Frontend</option>
          <option value={Category.SMARTCONTRACT}>Smart Contract</option>
          <option value={Category.OTHER}>Other</option>
        </Select>
        
        <Input
          label="Template Name"
          value={formData.name}
          onChange={(e) => handleChange('name', e.target.value)}
          required
        />
        
        <div className="space-y-1">
          <label className="block text-sm font-medium text-gray-700">
            Template Content
          </label>
          <textarea
            className="block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500 sm:text-sm"
            rows={8}
            value={formData.content}
            onChange={(e) => handleChange('content', e.target.value)}
            required
          />
        </div>
        
        <div className="flex gap-2 pt-4">
          <Button type="submit" disabled={loading}>
            {loading ? 'Saving...' : 'Save Template'}
          </Button>
          <Button type="button" variant="secondary" onClick={onCancel}>
            Cancel
          </Button>
        </div>
      </form>
    </div>
  )
}
