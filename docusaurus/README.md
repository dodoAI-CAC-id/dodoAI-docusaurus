# Service Name Documentation

This website is built using [Docusaurus](https://docusaurus.io/), a modern static website generator.

## File Structure

```
.
├── feature
│   └── feature-1
│       ├── design
│       │   ├── conceptual-data-diagram.md
│       │   ├── feature-api-1.md
│       │   ├── physical-data-model.md
│       │   └── sequence-diagram.md
│       ├── develop
│       │   ├── backend
│       │   │   └── api-design1.md
│       │   └── frontend
│       │       └── frontend-design1.md
│       ├── specification
│       │   ├── functional-requirement.md
│       │   ├── system-requirement.md
│       │   └── user-story-lists.md
│       └── test
│           └── test.md
├── index.md
└── overview
    ├── architecture-overview.md
    ├── business-flow.md
    ├── business-function-chart.md
    ├── business-requirement.md
    ├── non-function-requirement.md
    └── wireframe.md

```

## Installation

### Using Yarn:

```bash
$ yarn
```

### Using Docker:

First, ensure you have Docker installed ([Get Docker](https://docs.docker.com/get-docker/)).

## Local Development

### Using Yarn:

```bash
$ yarn start
```

This command starts a local development server and opens up a browser window. Most changes are reflected live without having to restart the server.

### Using Docker:

To start the development server inside Docker, ensuring the container is rebuilt each time, run:

```bash
$ docker-compose up --build
```

This command builds the Docker image, starts the development server inside the Docker container, and maps port 3000 of the container to port 3000 on your host machine. Most changes are reflected live without having to restart the container.

## Build

### Using Yarn:
```bash
$ yarn build
```
This command generates static content into the `build` directory and can be served using any static content hosting service.

### Run as Production
```bash
$ yarn serve
```

### Using Docker:

To build the static content inside Docker, run:

```bash
$ docker-compose run --rm docusaurus npm run build
```

## Deployment

### Using Yarn:

#### Using SSH:

```bash
$ USE_SSH=true yarn deploy
```

#### Not using SSH:

```bash
$ GIT_USER=<Your GitHub username> yarn deploy
```

If you are using GitHub pages for hosting, this command is a convenient way to build the website and push to the `gh-pages` branch.

### Using Docker:

To deploy the website using Docker, run:

```bash
$ docker-compose run --rm docusaurus npm run deploy
```

If you are using GitHub pages for hosting, this command builds the website and pushes it to the `gh-pages` branch.
```

This updated README now includes a detailed file structure, making it easier for developers to understand the organization of the project.


```

### How to Configurate docusaurus

Update `docusaurus.config.js` to ensure the site is properly configured:

**ファイルパス**: `docusaurus.config.js`

**ファイル内容**:

```javascript
// @ts-check

const lightCodeTheme = require('prism-react-renderer/themes/github');
const darkCodeTheme = require('prism-react-renderer/themes/dracula');

/** @type {import('@docusaurus/types').Config} */
const config = {
  title: 'Handbook',
  tagline: 'Handbook',
  favicon: 'img/handbook.ico',

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
          editUrl: 'https://github.com/58web3/handbook',
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
      title: 'Handbook',
      logo: {
        alt: 'Handbook Logo',
        src: 'img/handbook.png',
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
          title: 'Handbook',
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
              label: 'Handbook',
              href: 'https://58llm.link/main/',
            },
          ],
        },
      ],
      copyright: `Copyright © ${new Date().getFullYear()} Handbook, Inc.`,
    },
    prism: {
      theme: lightCodeTheme,
      darkTheme: darkCodeTheme,
    },
  },
};

module.exports = config;
```