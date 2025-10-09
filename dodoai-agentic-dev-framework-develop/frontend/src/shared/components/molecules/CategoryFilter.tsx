import React from 'react'
import { Category } from '@/features/template-management/domain/entities/Project'
import { Select } from '../atoms/Select'

interface CategoryFilterProps {
  value?: Category
  onChange: (category?: Category) => void
}

export function CategoryFilter({ value, onChange }: CategoryFilterProps) {
  return (
    <Select
      label="Category"
      value={value || ''}
      onChange={(e) => onChange(e.target.value as Category || undefined)}
    >
      <option value="">All Categories</option>
      <option value={Category.DESIGN}>Design</option>
      <option value={Category.API}>API</option>
      <option value={Category.FRONTEND}>Frontend</option>
      <option value={Category.SMARTCONTRACT}>Smart Contract</option>
      <option value={Category.OTHER}>Other</option>
    </Select>
  )
}
