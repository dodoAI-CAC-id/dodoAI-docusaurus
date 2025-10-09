import { useState, useEffect } from 'react'
import { apolloClient } from '@/core/graphql/client'
import { GraphQLTemplateRepository } from '@/features/template-management/infrastructure/repositories/GraphQLTemplateRepository'
import { GetTemplatesUseCase } from '@/features/template-management/application/usecases/GetTemplatesUseCase'
import { CreateTemplateUseCase } from '@/features/template-management/application/usecases/CreateTemplateUseCase'
import { Template, Category } from '@/features/template-management/domain/entities/Project'
import { TemplateManagementLayout } from '@/shared/components/templates/TemplateManagementLayout'
import { SearchBar } from '@/shared/components/molecules/SearchBar'
import { CategoryFilter } from '@/shared/components/molecules/CategoryFilter'
import { TemplateList } from '@/shared/components/organisms/TemplateList'
import { TemplateForm } from '@/shared/components/organisms/TemplateForm'
import { GraphVisualization } from '@/shared/components/organisms/GraphVisualization'
import { Button } from '@/shared/components/atoms/Button'

export function TemplateManagementPage() {
  const [viewMode, setViewMode] = useState<'list' | 'graph'>('list')
  const [templates, setTemplates] = useState<Template[]>([])
  const [loading, setLoading] = useState(true)
  const [showForm, setShowForm] = useState(false)
  const [selectedCategory, setSelectedCategory] = useState<Category | undefined>()
  
  const templateRepository = new GraphQLTemplateRepository(apolloClient)
  const getTemplatesUseCase = new GetTemplatesUseCase(templateRepository)
  const createTemplateUseCase = new CreateTemplateUseCase(templateRepository)

  const loadTemplates = async (filters?: { keyword?: string; category?: Category }) => {
    setLoading(true)
    try {
      const result = await getTemplatesUseCase.execute(filters)
      setTemplates(result)
    } catch (error) {
      console.error('Failed to load templates:', error)
    } finally {
      setLoading(false)
    }
  }

  useEffect(() => {
    loadTemplates()
  }, [])

  const handleSearch = (keyword: string) => {
    loadTemplates({ keyword, category: selectedCategory })
  }

  const handleCategoryChange = (category?: Category) => {
    setSelectedCategory(category)
    loadTemplates({ category })
  }

  const handleCreateTemplate = async (data: {
    name: string
    content: string
    taskName: string
    category: Category
    projectName: string
  }) => {
    try {
      let project = await templateRepository.getProjects().then(projects => 
        projects.find(p => p.name === data.projectName)
      )
      
      if (!project) {
        project = await templateRepository.createProject({
          name: data.projectName,
          description: `Project for ${data.projectName}`,
        })
      }

      let task = await templateRepository.getTasks(project.id).then(tasks =>
        tasks.find(t => t.name === data.taskName && t.category === data.category)
      )

      if (!task) {
        task = await templateRepository.createTask({
          name: data.taskName,
          category: data.category,
          projectId: project.id,
        })
      }

      await createTemplateUseCase.execute({
        name: data.name,
        content: data.content,
        taskId: task.id,
      })

      setShowForm(false)
      loadTemplates()
    } catch (error) {
      console.error('Failed to create template:', error)
    }
  }

  const handleDeleteTemplate = async (template: Template) => {
    if (confirm('Are you sure you want to delete this template?')) {
      try {
        await templateRepository.deleteTemplate(template.id)
        loadTemplates()
      } catch (error) {
        console.error('Failed to delete template:', error)
      }
    }
  }

  return (
    <div className="min-h-screen bg-gray-50">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="mb-6">
          <div className="flex items-center justify-between">
            <h1 className="text-3xl font-bold text-gray-900">Template Management</h1>
            <div className="flex gap-2">
              <Button
                onClick={() => setViewMode('list')}
                variant={viewMode === 'list' ? 'primary' : 'secondary'}
                size="sm"
              >
                List View
              </Button>
              <Button
                onClick={() => setViewMode('graph')}
                variant={viewMode === 'graph' ? 'primary' : 'secondary'}
                size="sm"
              >
                Graph View
              </Button>
            </div>
          </div>
        </div>

        {viewMode === 'list' ? (
          <TemplateManagementLayout>
            <div className="space-y-6">
              <div className="flex flex-col sm:flex-row gap-4 items-start sm:items-end">
                <div className="flex-1">
                  <SearchBar onSearch={handleSearch} />
                </div>
                <div className="w-full sm:w-48">
                  <CategoryFilter value={selectedCategory} onChange={handleCategoryChange} />
                </div>
                <Button onClick={() => setShowForm(true)}>
                  Add Template
                </Button>
              </div>

              {showForm && (
                <TemplateForm
                  onSubmit={handleCreateTemplate}
                  onCancel={() => setShowForm(false)}
                />
              )}

              <TemplateList
                templates={templates}
                loading={loading}
                onDelete={handleDeleteTemplate}
              />
            </div>
          </TemplateManagementLayout>
        ) : (
          <div className="bg-white rounded-lg shadow-sm p-6">
            <h2 className="text-xl font-semibold text-gray-900 mb-4">
              Template Relationship Graph
            </h2>
            <GraphVisualization />
          </div>
        )}
      </div>
    </div>
  )
}

export default TemplateManagementPage
