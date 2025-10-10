/**
 * Project Management sidebar items
 */
const projectManagementItems = [
  {
    type: "category",
    label: "Development Rules",
    items: [
      'project-management/development-rules/branch-name',
      'project-management/development-rules/documenting-pr-procedure',
      'project-management/development-rules/engineer_request_process',
      'project-management/development-rules/github-issue-creator',
      'project-management/development-rules/issue-registration',
      'project-management/development-rules/pull-request-review',
      'project-management/development-rules/setting-deadlines',
      'project-management/development-rules/update-github-project',
    ],
  },
  'project-management/github-setup',
  'project-management/github-project-setup',
  'project-management/github-milestone-setup',
  'project-management/standard-story-points',
  'project-management/docusaurus-setup',
  'project-management/cd-for-docusaurus',
];

module.exports = projectManagementItems;
