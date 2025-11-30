module.exports = [
  {
    type: 'category',
    label: 'Specification',
    key: 'frontend-specification',
    items: [
      'frontend/specification/ui-design-figma',
      'frontend/specification/ui-list',
    ],
  },  
  {
    type: 'category',
    label: 'Design',
    key: 'frontend-design',
    items: [
      'frontend/design/ui-component-design',
      'frontend/design/ui-component-library',
      'frontend/design/frontend-feature-module-design',
      'frontend/design/screen-design',
    ],
  },
  {
    type: 'category',
    label: '画面設計',
    key: 'frontend-screen-design',
    items: [
      'frontend/screen-design/view-screen',
      'frontend/screen-design/history-screen',
      'frontend/screen-design/reversed/view-screen-detected-list',
    ],
  },
  {
    type: 'category',
    label: 'Develop',
    key: 'frontend-develop',
    items: [
      'frontend/develop/atoms-ui-component-library',
      'frontend/develop/molecules-ui-component-library',
      'frontend/develop/organism-ui-component-library',
      'frontend/develop/templates-ui-component-library',      
      'frontend/develop/pages-ui-component-library',
    ],
  },  
  {
    type: 'category',
    label: 'Feature 1',
    items: [
      {
        type: 'category',
        label: 'Design',
        key: 'frontend-feature-1-design',
        items: [
          'frontend/feature-1/design/application-layer-design',
          'frontend/feature-1/design/composition-layer-design',
          'frontend/feature-1/design/domain-layer-design',
          'frontend/feature-1/design/infrastructure-layer-design',
          'frontend/feature-1/design/presentation-layer-design',
        ],
      },            
      {
        type: 'category',
        label: 'Develop',
        key: 'frontend-feature-1-develop',
        items: [
          'frontend/feature-1/develop/domain-layer',
          'frontend/feature-1/develop/application-layer',
          'frontend/feature-1/develop/presentation-layer',
          'frontend/feature-1/develop/infrastructure-layer',
          'frontend/feature-1/develop/composition-layer',
        ],
      },      
    ],
  },
];
