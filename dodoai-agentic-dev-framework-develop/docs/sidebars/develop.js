/**
 * develop sidebar items
 */
const developItems = [
  {
    type: "category",
    label: "Frontend",
    items: [
      'develop/frontend/atoms-ui-component-library',
      'develop/frontend/molecules-ui-component-library',
      'develop/frontend/organism-ui-component-library',
      'develop/frontend/pages-ui-component-library',
      'develop/frontend/ai-develop-all-screens',
      'develop/frontend/human-develop-fix-bugs',
      {
        type: "category",
        label: "Architecture Layers",
        items: [
          'develop/frontend/layers/domain-layer',
          'develop/frontend/layers/application-layer',
          'develop/frontend/layers/presentation-layer',
          'develop/frontend/layers/infrastructure-layer',
          'develop/frontend/layers/composition-layer',
        ],
      },
      {
        type: "category",
        label: "Mobile",
        items: [
          'develop/frontend/mobile/mobile-ui-component-dev',
          'develop/frontend/mobile/mobile-ui-page-dev',
        ],
      },
    ],
  },
  {
    type: "category",
    label: "Backend",
    items: [
      'develop/backend/api-design',  // API Design (Markdown)
      'develop/backend/setup-mock-with-swagger',
      'develop/backend/api-test-scenario-define-test-swagger',  // Test Scenario & Test
      'develop/backend/controller-dev-unittest',
      'develop/backend/service-dev-unittest',
      'develop/backend/model-dev-unittest',
      'develop/backend/switch-swagger-to-api',
      'develop/backend/api-test',            
      'develop/backend/auth-mock-server',  // Auth Mock Server
    ],
  },
  {
    type: "category",
    label: "Smart Contract",
    items: [
      'develop/smart-contract/smart-contract-spec',
      'develop/smart-contract/smart-contract-dev',
      'develop/smart-contract/smart-contract-unit-test',
      'develop/smart-contract/smart-contract-deploy',
      'develop/smart-contract/smart-contract-sample'
    ],
  },
  {
    type: "category",
    label: "Infra",
    items: [
      'infrastructure-template-terraform',  // Infrastructure Template (Terraform)
      'infrastructure-provisioning-files',  // Infrastructure Provisioning Files (Terraform)
      'infrastructure-deploy',  // Infrastructure Deploy
    ],
  }
];

module.exports = developItems;
