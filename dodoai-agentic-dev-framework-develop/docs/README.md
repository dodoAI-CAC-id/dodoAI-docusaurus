# Agentic Dev Framework Documentation Site

## Module Versions

![Version](https://img.shields.io/static/v1?label=Agentic Dev Framework%20Version&message=v0.9.0&color=blue)

Welcome to the Agentic Dev Framework documentation site. This site is built using Docusaurus, a modern static site generator.

## Overview

This repository serves as the source for the Agentic Dev Framework documentation, containing guides and manuals essential for our Standard Dev Flow (ADF) and Dev Standards.

## Directory Structure

Here’s a brief overview of the directory structure:

```bash
.
├── assets
│   ├── 58vpn-guilde-1.png
│   ├── 58vpn-guilde-2.png
│   ├── android-component.png
│   ├── api-test-scenario-define-test-swagger-1.png
│   ├── api-test-scenario-define-test-swagger-2.png
│   ├── api-test-scenario-define-test-swagger-3.png
│   ├── api-test-scenario-define-test-swagger-4.png
│   ├── app-arch.png
│   ├── atomic-design.png
│   ├── business-flow.png
│   ├── business-requirement-sample.png
│   ├── ci_settings_frontend.png
│   ├── conceptual-data-diagram.png
│   ├── controller_dev.png
│   ├── create-new-branch.png
│   ├── functional-requirements.png
│   ├── Agentic Dev Framework-template.png
│   ├── ios-component.png
│   ├── ios-view-controller.png
│   ├── issue_regstration.png
│   ├── llm-ecs.png
│   ├── logic_component_dev_api.png
│   ├── logic_component_test_code.png
│   ├── logic_component_test_scenario.png
│   ├── miro_example1.png
│   ├── miro_example2.png
│   ├── non-function-requirement.png
│   ├── notion-task.png
│   ├── physical-data-model.png
│   ├── refactor-figma-to-code.png
│   ├── sdf-front-components.png
│   ├── sequence-diagram.png
│   ├── storybook.png
│   ├── swagger.png
│   ├── swagger_define.png
│   ├── switch-swagger-to-api.png
│   ├── system-requirements-sample.png
│   ├── system-requirements.png
│   ├── template-mgmt-top.png
│   ├── ui_component_dev.png
│   ├── ui_component_dev_sample.png
│   ├── ui_component_test_code.png
│   ├── ui_component_test_scenario.png
│   ├── ui_integration_test_scenario.png
│   ├── ui_logic_integration_styling.png
│   ├── ui_logic_integration_styling_sample.png
│   ├── ui_page_component.png
│   ├── ui_page_dev.png
│   ├── user-story-lists-result.png
│   ├── user-story-lists-sample.png
│   ├── user-story-lists.png
│   ├── widgetbook.png
│   ├── wireframe.png
│   └── wireframe_sample.png
├── daily-report.md
├── index.md
├── pages
│   ├── 58vpn-connection-information.md
│   ├── define-mobile-app-test-plan.md
│   ├── design
│   │   ├── application-architecture.md
│   │   ├── conceptual-data-diagram.md
│   │   ├── infrastructure-architecture.md
│   │   ├── operation-architecture.md
│   │   ├── physical-data-model.md
│   │   ├── security-architecture.md
│   │   ├── sequence-diagram.md
│   │   ├── swagger.md
│   │   ├── ui-component-design.md
│   │   └── ui-design-figma.md
│   ├── design.md
│   ├── develop
│   │   ├── backend
│   │   │   ├── api-design.md
│   │   │   ├── api-test-scenario-define-test-swagger.md
│   │   │   ├── api-test.md
│   │   │   ├── controller-dev-unittest.md
│   │   │   ├── model-dev-unittest.md
│   │   │   ├── service-dev-unittest.md
│   │   │   ├── setup-mock-with-swagger.md
│   │   │   └── switch-swagger-to-api.md
│   │   ├── cicd
│   │   │   ├── cd-setting.md
│   │   │   ├── ci-setting-api-testing.md
│   │   │   ├── ci-setting-backend-unit-testing.md
│   │   │   ├── ci-setting-frontend-unit-testing.md
│   │   │   └── ci.md
│   │   ├── frontend
│   │   │   ├── figma-to-code.md
│   │   │   ├── frontend-getting-started.md
│   │   │   ├── logic-component-dev-test.md
│   │   │   ├── mobile
│   │   │   │   ├── mobile-ui-component-dev.md
│   │   │   │   └── mobile-ui-page-dev.md
│   │   │   ├── ui-component-dev-test.md
│   │   │   ├── ui-component-library.md
│   │   │   └── ui-page-dev-test.md
│   │   └── smart-contract
│   │       ├── smart-contract-deploy.md
│   │       ├── smart-contract-dev.md
│   │       ├── smart-contract-spec.md
│   │       └── smart-contract-unit-test.md
│   ├── infrastructure-deploy.md
│   ├── infrastructure-provisioning-files.md
│   ├── infrastructure-template-terraform.md
│   ├── project-management
│   │   ├── branch-name.md
│   │   ├── documenting-pr-procedure.md
│   │   ├── engineer_request_process.md
│   │   ├── github-issue-creator.md
│   │   ├── issue-registration.md
│   │   ├── pull-request-review.md
│   │   ├── roles-and-responsibilities.md
│   │   ├── setting-deadlines.md
│   │   ├── setup-notion-github.md
│   │   ├── sprint-planning-retrospective.md
│   │   ├── team-status-tracking-backend.md
│   │   ├── team-status-tracking-frontend.md
│   │   └── update-github-project.md
│   ├── register-app-store.md
│   ├── release_add-tag_and_build-binary.md
│   ├── specification
│   │   ├── business-flow.md
│   │   ├── business-function-chart.md
│   │   ├── business-requirement.md
│   │   ├── design-system.md
│   │   ├── functional-requirement.md
│   │   ├── non-functional-requirement.md
│   │   ├── system-requirements.md
│   │   ├── user-story-lists.md
│   │   └── wireframe.md
│   ├── specification.md
│   ├── agentic-dev-framework
│   │   ├── agentic-dev-framework.md
│   │   └── what-is-sdf.md
│   ├── system-test-scenario.md
│   ├── system-test.md
│   ├── ui-integration-test-scenario.md
│   └── update-Agentic Dev Framework.md
└── project-management.md

```

## Installation

To set up your local development environment, install the necessary dependencies:

```bash
npm install
```

## Running Docusaurus

Start the local development server with:

```bash
npm start
```

## Internationalization (i18n) Setup

To build and run the project with internationalization (i18n) support, follow the steps below.

### Important Usage Note

**For proper i18n functionality, you must build the site first and then serve it:**

```bash
npm run build
npm run serve
```

The development server (`npm start`) may not properly serve i18n content until the site is built first. This is because Docusaurus needs to generate the static files for each locale during the build process.

### Supported Languages

This Agentic Dev Framework supports the following languages:
- **English** (en) - Default language
- **Japanese** (ja) - 日本語
- **Vietnamese** (vi) - Tiếng Việt

### Setup with npm

1. Install dependencies and update language files:

   ```bash
   npm install
   npm run docusaurus write-translations -- --locale <your-locale>
   ```

2. **Recommended**: Build and serve the static site for i18n:

   ```bash
   npm run build
   npm run serve
   ```

3. Alternative: Start the development server with the desired locale (may not work properly for i18n):

   ```bash
   npm run start -- --locale <your-locale>
   ```

### Setup with Yarn

1. Install dependencies and update language files:

   ```bash
   yarn install
   yarn docusaurus write-translations --locale <your-locale>
   ```

2. **Recommended**: Build and serve the static site for i18n:

   ```bash
   yarn build
   yarn serve
   ```

3. Alternative: Start the development server with the desired locale (may not work properly for i18n):

   ```bash
   yarn start --locale <your-locale>
   ```

Replace `<your-locale>` with the locale you wish to use (e.g., `ja`, `vi`, etc.).

### Language Switching

Once the site is built and served, you can switch between languages using the language dropdown in the navigation bar:
- Access Japanese content at `/ja/`
- Access Vietnamese content at `/vi/`
- Access English content at `/` (default)

## Adding a New Version

To create a new version of the documentation:

1. Run the versioning command with the desired version number:

    ```bash
    npx docusaurus docs:version 0.1.1
    ```

2. Update `docusaurus.config.js` to include the new version:

    ```javascript
    module.exports = {
      // ... existing config
      presets: [
        [
          'classic',
          /** @type {import('@docusaurus/preset-classic').Options} */
          {
            docs: {
              // ... existing options
              routeBasePath: '/', // Base URL path
              sidebarPath: require.resolve('./sidebars.js'),
              editUrl: 'https://github.com/your-org/your-repo/edit/main/website/',
              includeCurrentVersion: true,
              lastVersion: '0.1.5',
              versions: {
                current: {
                  label: 'Next',
                  path: 'next',
                },
                '0.1.1': {
                  label: '0.1.1',
                  path: '/',
                },
              },
            },
            // ... other options
          },
        ],
      ],
      // ... other configs
    };
    ```

### Docker Setup

To build and run the project using Docker:

```bash
docker-compose up --build
```

If you need to rebuild the Docker image:

```bash
docker-compose down
docker-compose up --build
```

### Sidebar Configuration

Update `sidebars.js` to include the newly added pages:

**ファイルパス**: `sidebars.js`

**ファイル内容**:

```javascript
// @ts-check

/** @type {import('@docusaurus/plugin-content-docs').SidebarsConfig} */
const sidebars = {
  mySidebar: [
    {
      type: 'doc',
      id: 'index',
      label: 'Introduction',
    },
    {
      type: 'category',
      label: 'Standard Dev Flow(ADF)',
      items: [
        'pages/what-is-sdf',
        'pages/integration-workflow-dify',
        'pages/specification',
        'pages/design',
        'pages/agentic-dev-framework',
      ],
    },
    {
      type: 'category',
      label: 'Dev Standard',
      items: [
        'pages/roles-and-responsibilities',
        'pages/setup-notion-github',
        'pages/sprint-planning-retrospective',
        'pages/issue-registration',
        'pages/update-github-project',
        'pages/pull-request-review',
      ],
    },
    {
      type: 'category',
      label: 'CI/CD',
      items: [
        'pages/ci',
        'pages/cd',
      ],
    },
    {
      type: 'category',
      label: 'How to update Agentic Dev Framework',
      items: ['pages/update-Agentic Dev Framework'],
    },
    {
      type: 'category',
      label: 'Daily Report',
      items: ['daily-report'],
    },
    {
      type: 'doc',
      id: 'version',
      label: 'Version',
    },
  ],
};

module.exports = sidebars;
```

### Configuration File

Update `docusaurus.config.js` to ensure the site is properly configured:

**ファイルパス**: `docusaurus.config.js`

**ファイル内容**:

```javascript
// @ts-check

const lightCodeTheme = require('prism-react-renderer/themes/github');
const darkCodeTheme = require('prism-react-renderer/themes/dracula');

/** @type {import('@docusaurus/types').Config} */
const config = {
  title: 'Agentic Dev Framework',
  tagline: 'Agentic Dev Framework',
  favicon: 'img/Agentic Dev Framework.ico',

  url: 'https://example.com',
  baseUrl: '/',
  trailingSlash: true,

  onBrokenLinks: 'throw',
  onBrokenMarkdownLinks: 'warn',

  i18n: {
    defaultLocale: 'ja',
    locales: ['ja'],
  },

  presets: [
    [
      'classic',
      /** @type {import('@docusaurus/preset-classic').Options} */
      ({
        docs: {
          routeBasePath: '/', // Base URL path
          sidebarPath: require.resolve('./sidebars.js'),
          editUrl: 'https://github.com/58web3/Agentic Dev Framework',
          includeCurrentVersion: true,
          lastVersion: '0.1.5',
          versions: {
            current: {
              label: 'Next',
              path: 'next',
            },
            '0.1.5': {
              label: '0.1.5',
              path: '/',
            },
          },
        },
        blog: {
          showReadingTime: true,
        },
        theme: {
          customCss: require.resolve('./src/css/custom.css'),
        },
      }),
    ],
  ],

  themeConfig: {
    docs: {
      sidebar: {
        hideable: true,
        autoCollapseCategories: true,
      },
      versionPersistence: 'localStorage',
    },
    colorMode: {
      defaultMode: 'light',
      disableSwitch: false,
      respectPrefersColorScheme: true,
    },
    navbar: {
      title: 'Agentic Dev Framework',
      logo: {
        alt: 'Agentic Dev Framework Logo',
        src: 'img/Agentic Dev Framework.png',
      },
      items: [
        {
          type: 'docsVersionDropdown',
          position: 'left',
        },
        {
          to: '/home', // Moves the custom homepage content to /home URL
          label: 'Guides',
          position: 'left',
        },        
      ],
    },
    footer: {
      style: 'dark',
      links: [
        {
          title: 'Agentic Dev Framework',
          items: [
            {
              label: 'Guides',
              to: '/',
            },
            {
              label: 'Blog',
              to: '/blog',
            },
          ],
        },
        {
          title: 'Links',
          items: [
            {
              label: 'Agentic Dev Framework',
              href: 'https://58llm.link/main/',
            },
          ],
        },
      ],
      copyright: `Copyright © ${new Date().getFullYear()} Agentic Dev Framework, Inc.`,
    },
    prism: {
      theme: lightCodeTheme,
      darkTheme: darkCodeTheme,
    },
  },
};

module.exports = config;
