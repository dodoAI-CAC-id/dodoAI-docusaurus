// @ts-check
const lightCodeTheme = require('prism-react-renderer/themes/github');
const darkCodeTheme = require('prism-react-renderer/themes/dracula');
import dotenv from 'dotenv';
dotenv.config({path: './.env'});

/** @type {import('@docusaurus/types').Config} */
const config = {
  title: 'Docusarus',
  tagline: 'Docusarus',
  // favicon: 'img/favicon.ico',

  // Set the production url of your site here
  url: 'https://docs.dodoai.cacidentity.com/',
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
    authApiUrl: process.env.REACT_APP_AUTH_API_URL || '',
  },

  trailingSlash: false,
  // GitHub pages deployment config.
  // If you aren't using GitHub pages, you don't need these.
  organizationName: 'CAC', // Usually your GitHub org/user name.
  projectName: 'Docs', // Usually your repo name.

  onBrokenLinks: 'throw',
  onBrokenMarkdownLinks: 'warn',

  // Adding Mermaid diagram support
  markdown: {mermaid: true,}, 
  themes: ['@docusaurus/theme-mermaid'],  

  i18n: {
    defaultLocale: 'en',
    locales: ['en','ja'],
    localeConfigs: {
      en: {
        label: 'English',
      },
      ja: {
        label: '日本語',
      },
    },
  },

  presets: [
    [
      'classic',
      /** @type {import('@docusaurus/preset-classic').Options} */
      ({
        docs: {
          sidebarPath: require.resolve('./sidebars.js'), // サイドバーの設定ファイルを指定します。
          routeBasePath: '/', // ドキュメントのルートURLを設定します。
          editUrl:
            'https://docs.58llm.link/docs',
            lastVersion: 'current', // ドキュメントの最後のバージョンを指定します。
            includeCurrentVersion: true, // 現在のバージョンを含めるかどうかを設定します。
            versions: {
              // next: {
              //   label: 'Next', // 現在のバージョンのラベルを設定します。
              //   path: 'next', // 現在のバージョンのURLパスを設定します。
              // },
              current: {
                label: 'current',
                path: '/',
              },            
            },            
        },
        theme: {
          customCss: './src/css/custom.css',
        },
      }),
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
  ],  themeConfig:
    /** @type {import('@docusaurus/preset-classic').ThemeConfig} */
    ({
      image: 'img/docusaurus-social-card.jpg',
      navbar: {
        title: 'Docusaurus',
        // logo: {
        //   alt: '',
        //   src: 'img/logo.svg',
        // },
        items: [
          {
            type: 'docsVersionDropdown',
            position: 'left',
          },                    
          {
            type: 'docSidebar',
            sidebarId: 'tutorialSidebar',
            position: 'left',
            label: 'Docs',
          },
          {
            type: 'localeDropdown',
            position: 'left',
          },
        ],
      },
      footer: {
        style: 'dark', // フッターのスタイルを設定します。'dark' でダークテーマにします。
        links: [], // フッターリンクを設定しますが、ここでは空にしています。
        copyright: `Copyright © ${new Date().getFullYear()} 58 inc. Built with Docusaurus.`, // フッターに表示する著作権情報を設定します。
      },
       prism: {
        theme: lightCodeTheme,
        darkTheme: darkCodeTheme,
      },
      docs: {
        sidebar: {      
          hideable: true,
        },
      },
    }),
};

export default config;
