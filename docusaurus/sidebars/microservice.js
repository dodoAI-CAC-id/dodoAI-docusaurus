module.exports = [
  {
    type: 'category',
    label: 'Overview',
    items: [
      'microservice/overview/microservice-business-requirement',
      'microservice/overview/microservice-non-functional-requirement',
      'microservice/overview/microservice-system-requirements',
      'microservice/overview/microservice-application-architecture',
      'microservice/overview/microservice-runtime-architecture',
      'microservice/overview/microservice-conceptual-data-diagram',
      'microservice/overview/microservice-er-diagram',
      'microservice/overview/microservice-physical-data-diagram',
    ],
  },
  {
    type: 'category',
    label: 'Specification',
    key: 'microservice-specification',
    items: [
      'microservice/specification/detail-functional-requirement',
    ],
  },  
  {
    type: 'category',
    label: 'Design',
    key: 'microservice-design',
    items: [
      'microservice/design/sequence-diagram',
      'microservice/design/microservice-api-list',
      'microservice/design/microservice-swagger',
      'microservice/design/feature-api-1',
    ],
  },
  {
    type: 'category',
    label: 'Develop',
    key: 'microservice-develop',
    items: [
      'microservice/develop/api-design',
      'microservice/develop/setup-mock-with-swagger',
      'microservice/develop/controller-dev-unittest',
      'microservice/develop/service-dev-unittest',
      'microservice/develop/model-dev-unittest',
    ],
  },

  {
    type: 'category',
    label: 'Test',
    key: 'microservice-test',
    items: [
      'microservice/test/unit-tests-planning',
      'microservice/test/microservice-unit-tests-planning',
      'microservice/test/microservice-api-tests-planning',
      'microservice/test/microservice-api-tests-scenario',
    ],
  },
];
