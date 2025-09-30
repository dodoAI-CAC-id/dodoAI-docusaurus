---
id: design-system
title: Design System
---

# Design System

## Overview

This document defines the comprehensive design system for the dodo AI platform, establishing consistent visual and interaction patterns across all user interfaces and touchpoints.

## Design Principles

### 1. Clarity and Simplicity
- **Clear Visual Hierarchy**: Use typography, spacing, and color to guide user attention
- **Minimal Cognitive Load**: Reduce complexity and focus on essential functionality
- **Intuitive Navigation**: Provide clear pathways and predictable interactions
- **Progressive Disclosure**: Reveal information and options as needed

### 2. Consistency and Coherence
- **Unified Visual Language**: Maintain consistent styling across all components
- **Predictable Interactions**: Use familiar patterns and behaviors
- **Systematic Approach**: Apply design tokens and rules consistently
- **Cross-Platform Harmony**: Ensure coherence across different devices and platforms

### 3. Accessibility and Inclusion
- **Universal Design**: Create interfaces usable by people of all abilities
- **WCAG Compliance**: Meet or exceed accessibility guidelines
- **Keyboard Navigation**: Support full keyboard accessibility
- **Screen Reader Compatibility**: Ensure proper semantic markup and labels

### 4. Efficiency and Performance
- **Fast Loading**: Optimize assets and minimize resource usage
- **Responsive Design**: Adapt seamlessly to different screen sizes
- **Touch-Friendly**: Design for various input methods
- **Performance-First**: Prioritize speed and responsiveness

## Visual Foundation

### Color Palette

#### Primary Colors
- **Primary Blue**: #0066CC
  - Light: #3385D6
  - Dark: #004499
  - Usage: Primary actions, links, focus states

- **Secondary Green**: #00AA44
  - Light: #33BB66
  - Dark: #007733
  - Usage: Success states, confirmations, positive actions

#### Neutral Colors
- **Gray Scale**:
  - Gray 900: #1A1A1A (Primary text)
  - Gray 700: #4A4A4A (Secondary text)
  - Gray 500: #7A7A7A (Tertiary text)
  - Gray 300: #CCCCCC (Borders, dividers)
  - Gray 100: #F5F5F5 (Background, surfaces)
  - White: #FFFFFF (Primary background)

#### Semantic Colors
- **Error Red**: #CC0000
  - Light: #FF3333
  - Dark: #990000
  - Usage: Error states, destructive actions

- **Warning Orange**: #FF8800
  - Light: #FFAA33
  - Dark: #CC6600
  - Usage: Warning states, caution indicators

- **Info Blue**: #0088CC
  - Light: #33AADD
  - Dark: #006699
  - Usage: Information states, neutral notifications

### Typography

#### Font Family
- **Primary**: Inter, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif
- **Monospace**: 'Fira Code', 'Monaco', 'Consolas', monospace

#### Type Scale
- **Heading 1**: 32px / 40px (2rem / 2.5rem)
- **Heading 2**: 24px / 32px (1.5rem / 2rem)
- **Heading 3**: 20px / 28px (1.25rem / 1.75rem)
- **Heading 4**: 18px / 24px (1.125rem / 1.5rem)
- **Body Large**: 16px / 24px (1rem / 1.5rem)
- **Body**: 14px / 20px (0.875rem / 1.25rem)
- **Body Small**: 12px / 16px (0.75rem / 1rem)
- **Caption**: 10px / 14px (0.625rem / 0.875rem)

#### Font Weights
- **Regular**: 400
- **Medium**: 500
- **Semibold**: 600
- **Bold**: 700

### Spacing System

#### Base Unit: 4px

#### Spacing Scale
- **xs**: 4px (0.25rem)
- **sm**: 8px (0.5rem)
- **md**: 16px (1rem)
- **lg**: 24px (1.5rem)
- **xl**: 32px (2rem)
- **2xl**: 48px (3rem)
- **3xl**: 64px (4rem)

### Grid System

#### Breakpoints
- **Mobile**: 320px - 767px
- **Tablet**: 768px - 1023px
- **Desktop**: 1024px - 1439px
- **Large Desktop**: 1440px+

#### Grid Specifications
- **Columns**: 12-column grid system
- **Gutters**: 16px (mobile), 24px (tablet+)
- **Margins**: 16px (mobile), 24px (tablet), 32px (desktop)
- **Max Width**: 1200px (content container)

## Component Library

### Basic Components

#### Button
- **Primary Button**: Main call-to-action
- **Secondary Button**: Secondary actions
- **Tertiary Button**: Subtle actions
- **Icon Button**: Icon-only actions
- **States**: Default, Hover, Active, Disabled, Loading

#### Input Fields
- **Text Input**: Single-line text entry
- **Textarea**: Multi-line text entry
- **Select**: Dropdown selection
- **Checkbox**: Multiple selection
- **Radio**: Single selection
- **Switch**: Toggle states

#### Navigation
- **Header Navigation**: Primary site navigation
- **Sidebar Navigation**: Secondary navigation
- **Breadcrumbs**: Hierarchical navigation
- **Pagination**: Content navigation
- **Tabs**: Content organization

### Complex Components

#### Cards
- **Basic Card**: Content container
- **Media Card**: Image/video content
- **Action Card**: Interactive content
- **Status Card**: Information display

#### Modals and Overlays
- **Modal Dialog**: Focused interactions
- **Drawer**: Side panel content
- **Tooltip**: Contextual information
- **Popover**: Additional content

#### Data Display
- **Table**: Structured data
- **List**: Sequential content
- **Timeline**: Chronological content
- **Chart**: Data visualization

### Form Components

#### Form Layout
- **Form Group**: Related field grouping
- **Field Label**: Input identification
- **Help Text**: Additional guidance
- **Error Message**: Validation feedback

#### Validation States
- **Default**: Normal state
- **Focus**: Active input
- **Success**: Valid input
- **Error**: Invalid input
- **Disabled**: Inactive input

## Interaction Patterns

### Micro-interactions
- **Hover Effects**: Subtle feedback on interactive elements
- **Loading States**: Progress indication during operations
- **Transitions**: Smooth state changes
- **Animations**: Purposeful motion design

### Navigation Patterns
- **Progressive Navigation**: Step-by-step processes
- **Contextual Navigation**: Related content access
- **Search and Filter**: Content discovery
- **Breadcrumb Navigation**: Location awareness

### Feedback Patterns
- **Success Feedback**: Positive confirmation
- **Error Handling**: Clear error communication
- **Loading Indicators**: Progress communication
- **Empty States**: Guidance for empty content

## Layout Patterns

### Page Layouts
- **Dashboard Layout**: Overview and widgets
- **List Layout**: Content browsing
- **Detail Layout**: Focused content view
- **Form Layout**: Data entry and editing

### Content Organization
- **Information Architecture**: Logical content structure
- **Content Hierarchy**: Clear information priority
- **Scannable Content**: Easy content consumption
- **Progressive Disclosure**: Layered information reveal

## Accessibility Guidelines

### WCAG 2.1 AA Compliance
- **Color Contrast**: Minimum 4.5:1 ratio for normal text
- **Focus Indicators**: Visible focus states for all interactive elements
- **Keyboard Navigation**: Full keyboard accessibility
- **Screen Reader Support**: Proper semantic markup and ARIA labels

### Inclusive Design Practices
- **Alternative Text**: Descriptive alt text for images
- **Captions and Transcripts**: For audio and video content
- **Flexible Text Sizing**: Support for text scaling up to 200%
- **Motion Preferences**: Respect reduced motion preferences

## Implementation Guidelines

### Design Tokens
- **CSS Custom Properties**: Centralized design values
- **Token Categories**: Color, typography, spacing, shadows
- **Token Naming**: Consistent naming conventions
- **Token Documentation**: Clear usage guidelines

### Component Development
- **Atomic Design**: Build from atoms to organisms
- **Reusable Components**: Maximize component reuse
- **Props and Variants**: Flexible component configuration
- **Documentation**: Comprehensive component documentation

### Quality Assurance
- **Design Reviews**: Regular design consistency checks
- **Accessibility Testing**: Automated and manual testing
- **Cross-browser Testing**: Ensure compatibility
- **Performance Monitoring**: Track design system impact

This design system serves as the foundation for creating consistent, accessible, and user-friendly interfaces across the dodo AI platform, ensuring a cohesive user experience while maintaining development efficiency.
