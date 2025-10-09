import React from 'react'
import { Routes, Route } from 'react-router-dom'
import TemplateManagementPage from '@/pages/TemplateManagementPage'

function App() {
  return (
    <div className="min-h-screen bg-gray-50">
      <Routes>
        <Route path="/" element={<TemplateManagementPage />} />
        <Route path="/templates" element={<TemplateManagementPage />} />
      </Routes>
    </div>
  )
}

export default App
