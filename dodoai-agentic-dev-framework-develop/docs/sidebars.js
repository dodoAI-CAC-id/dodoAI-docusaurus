/**
 * Creating a sidebar enables you to:
 - create an ordered group of docs
 - render a "Next" and "Previous" button for each doc
 - provide a table of contents on the right side of each doc
 - and more! Check out the docs for more details.

 * @type {import('@docusaurus/plugin-content-docs').SidebarsConfig}
 */

const specification = require('./sidebars/specification');
const agenticDevFramework = require('./sidebars/agentic-dev-framework');
const systemFlows = require('./sidebars/system-flows');
const frontend = require('./sidebars/frontend');
const microservice = require('./sidebars/microservice');
const infrastructure = require('./sidebars/infrastructure');
const devops = require('./sidebars/devops');
const test = require('./sidebars/test');
const projectManagement = require('./sidebars/project-management');

const sidebars = {
  tutorialSidebar: [
    'index',
    {
      type: 'category',
      label: 'Agentic Dev Framework',
      items: agenticDevFramework,
    },
    {
      type: 'category',
      label: 'Specification',
      items: specification,
    },
    {
      type: 'category',
      label: 'System Flows',
      items: systemFlows,
    },
    {
      type: 'category',
      label: 'Frontend',
      items: frontend,
    },
    {
      type: 'category',
      label: 'Microservice',
      items: microservice,
    },
    {
      type: 'category',
      label: 'Infrastructure',
      items: infrastructure,
    },
    {
      type: 'category',
      label: 'DevOps',
      items: devops,
    },
    {
      type: 'category',
      label: 'Test',
      items: test,
    },
    {
      type: 'category',
      label: 'Project Management',
      items: projectManagement,
    },
  ],
};

module.exports = sidebars;
