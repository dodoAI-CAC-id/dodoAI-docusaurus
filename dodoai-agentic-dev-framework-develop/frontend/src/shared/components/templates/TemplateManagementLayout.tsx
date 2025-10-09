import React, { ReactNode } from 'react'
import { Text } from '../atoms/Text'

interface TemplateManagementLayoutProps {
  children: ReactNode
}

export function TemplateManagementLayout({ children }: TemplateManagementLayoutProps) {
  return (
    <div className="min-h-screen bg-gray-50">
      <header className="bg-white shadow-sm border-b border-gray-200">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4">
          <Text variant="h1">Template Management</Text>
          <Text variant="body" className="mt-2">
            Manage your development templates for the Agentic Dev Framework
          </Text>
        </div>
      </header>
      
      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        {children}
      </main>
    </div>
  )
}
