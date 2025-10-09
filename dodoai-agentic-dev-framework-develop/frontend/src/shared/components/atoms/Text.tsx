import React, { ReactNode } from 'react'
import { clsx } from 'clsx'

interface TextProps {
  children: ReactNode
  variant?: 'h1' | 'h2' | 'h3' | 'body' | 'caption'
  className?: string
}

export function Text({ children, variant = 'body', className }: TextProps) {
  const Component = variant.startsWith('h') ? variant : 'p'
  
  return (
    <Component
      className={clsx(
        {
          'text-3xl font-bold text-gray-900': variant === 'h1',
          'text-2xl font-semibold text-gray-900': variant === 'h2',
          'text-xl font-medium text-gray-900': variant === 'h3',
          'text-base text-gray-700': variant === 'body',
          'text-sm text-gray-500': variant === 'caption',
        },
        className
      )}
    >
      {children}
    </Component>
  )
}
