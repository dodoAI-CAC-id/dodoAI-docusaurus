/**
 * Creating a sidebar enables you to:
 - create an ordered group of docs
 - render a sidebar for each doc of that group
 - provide next/previous navigation

 The sidebars can be generated from the filesystem, or explicitly defined here.

 Create as many sidebars as you want.
 */

// @ts-check

const specification = require('./sidebars/specification');
const systemFlows = require('./sidebars/system-flows');
const frontend = require('./sidebars/frontend');
const microservice = require('./sidebars/microservice');
const infrastructure = require('./sidebars/infrastructure');
const devops = require('./sidebars/devops');
const test = require('./sidebars/test');
const projectManagement = require('./sidebars/project-management');
const design = require('./sidebars/design');
const develop = require('./sidebars/develop');

const sidebars = {
  tutorialSidebar: [
    'index',
    {
      type: 'category',
      label: 'Specification',
      key: 'main-specification',
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
      label: 'DevOps',
      items: devops,
    },
    {
      type: 'category',
      label: 'Test',
      key: 'main-test',
      items: test,
    },
  ],
};

module.exports = sidebars;
