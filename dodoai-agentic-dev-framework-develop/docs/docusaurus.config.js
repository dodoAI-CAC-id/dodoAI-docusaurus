// @ts-check
const lightCodeTheme = require('prism-react-renderer/themes/github');
const darkCodeTheme = require('prism-react-renderer/themes/dracula');
import dotenv from 'dotenv';
dotenv.config({path: './.env'});

/** @type {import('@docusaurus/types').Config} */
const config = {
  title: 'agentic-dev-framework',
  tagline: 'agentic-dev-framework',
  favicon: 'img/agentic-dev-framework.ico',

  url: 'https://agentic-dev-framework.58llm.link/',
  baseUrl: '/',
  customFields: {
    firebaseApiKey: process.env.REACT_APP_FIREBASE_API_KEY || "",
    firebaseAuthDomain: process.env.REACT_APP_FIREBASE_AUTH_DOMAIN || "",
    firebaseProjectId: process.env.REACT_APP_FIREBASE_PROJECT_ID || "",
    firebaseStorageBucket: process.env.REACT_APP_FIREBASE_STORAGE_BUCKET || "",
    firebaseMessagingSenderId: process.env.REACT_APP_FIREBASE_MESSAGING_SENDER_ID || "",
    firebaseAppId: process.env.REACT_APP_FIREBASE_APP_ID || "",
    firebaseMeasurementId: process.env.REACT_APP_FIREBASE_MEASUREMENT_ID || "",
    // GitHub OAuth configuration
    githubAuthEnabled: process.env.REACT_APP_GITHUB_AUTH_ENABLED === 'true',
    githubRepoOwner: process.env.REACT_APP_GITHUB_REPO_OWNER || '58web3',
    githubRepoName: process.env.REACT_APP_GITHUB_REPO_NAME || '',
    githubClientId: process.env.REACT_APP_GITHUB_CLIENT_ID || '',
    authApiUrl: process.env.REACT_APP_AUTH_API_URL || 'https://docs-auth.58llm.link',
  },
  onBrokenLinks: 'throw',
  onBrokenMarkdownLinks: 'warn',

  i18n: {
    defaultLocale: 'en',
    locales: ['en', 'ja', 'vi'],
    localeConfigs: {
      en: { label: 'English' },
      ja: { label: '日本語' },
      vi: { label: 'Tiếng Việt' },
    },
  },

  // ✅ Mermaid テーマを有効化
  themes: ['@docusaurus/theme-mermaid'],
  
  // ✅ Mermaid マークダウン処理を有効化
  markdown: {
    mermaid: true,
  },

  // ✅ Mermaid の表示テーマ設定
  themeConfig: {
    mermaid: {
      theme: { light: 'neutral', dark: 'dark' },
    },
    versionPersistence: 'localStorage',
    colorMode: {
      defaultMode: 'light',
      disableSwitch: false,
      respectPrefersColorScheme: true,
    },
    navbar: {
      title: 'agentic-dev-framework',
      logo: {
        alt: 'agentic-dev-framework Logo',
        src: 'img/agentic-dev-framework.png',
      },
      items: [
        {
          type: 'docsVersionDropdown',
          to: '/',
          label: 'Docs',
          position: 'left',
        },
        {
          type: 'localeDropdown',
          position: 'left',
        },
      ],
    },
    footer: {
      style: 'dark',
      links: [
        {
          title: 'agentic-dev-framework',
          items: [{ 
            label: 'Guides', 
            to: '/',
            translationId: 'theme.footer.links.item.label.Guides'
          }],
        },
        {
          title: 'Links',
          items: [
            {
              label: 'agentic-dev-framework',
              href: 'https://agentic-dev-framework.58llm.link/',
              translationId: 'theme.footer.links.item.label.agentic-dev-framework'
            },
          ],
        },
      ],
      copyright: `Copyright © ${new Date().getFullYear()} 58, Inc.`,
    },
    prism: {
      theme: lightCodeTheme,
      darkTheme: darkCodeTheme,
    },
  },

  presets: [
    [
      'classic',
      {
        docs: {
          routeBasePath: '/',
          sidebarPath: require.resolve('./sidebars.js'),
          editUrl: 'https://github.com/58web3/agentic-dev-framework',
          includeCurrentVersion: true,
          lastVersion: 'current',
          versions: {
            current: {
              label: 'v0.9.0',
              path: '/',
            },
          },
          // ✅ v3では mermaid: true をここに書かないこと！
        },
        blog: {
          showReadingTime: true,
        },
        theme: {
          customCss: require.resolve('./src/css/custom.css'),
        },
      },
    ],
  ],

  plugins: [
    [
      require.resolve('@easyops-cn/docusaurus-search-local'),
      {
        hashed: false,
        indexDocs: true,
        indexBlog: false,
        indexPages: false,
        language: ['ja', 'en'],
        docsRouteBasePath: '/',
        docsDir: 'docs',
      },
    ],
  ],
};

module.exports = config;
