# Goal
* フロントエンドアプリケーションの１画面を構築すること

# instruction
* 開発言語はFlutter
* Webアプリケーションを開発する
* フロントエンドの開発は、必ず以下のディレクトリ内の各種ドキュメントに記載のガイドを参考にすること
    - C:\Users\ynara\Dropbox\_private\_Study\_GitHub\projects\dodoAI_mamoAI\dodoai-agentic-dev-framework-develop\docs\docs\frontend\design
    - C:\Users\ynara\Dropbox\_private\_Study\_GitHub\projects\dodoAI_mamoAI\dodoai-agentic-dev-framework-develop\docs\docs\frontend\develop
    - C:\Users\ynara\Dropbox\_private\_Study\_GitHub\projects\dodoAI_mamoAI\dodoai-agentic-dev-framework-develop\docs\docs\frontend\modular-onion-architecture
* 以下の画面設計書に基づき、フロントエンド画面を構築すること
    - C:\Users\ynara\Dropbox\_private\_Study\_GitHub\projects\dodoAI_mamoAI\docusaurus\docs\frontend\screen-design\history-screen.md
* 上記の画面設計書上で記載されているAPIと疎通するインターフェースも実装すること。各種APIの定義は以下に記載されている
    - C:\Users\ynara\Dropbox\_private\_Study\_GitHub\projects\dodoAI_mamoAI\docusaurus\static\swagger\v2\microservice.yaml
* 画面のUIは、以下の画像にあるデザインを実現すること
    - C:\Users\ynara\Dropbox\_private\_Study\_GitHub\projects\dodoAI_mamoAI\docusaurus\static\img\docs\frontend\history-screen.png
* UIはAtomic Designに基づき、流用可能なデザインコンポーネントをまずは開発し、それらを活用して画面のUIを構成すること
    - また、その過程で、Widgetbookに必ずUIコンポーネントを登録すること

# Target Folders
* フロントエンドアプリケーションは、以下のディレクトリ内で開発すること
    - C:\Users\ynara\Dropbox\_private\_Study\_GitHub\projects\dodoAI_mamoAI\src\frontend

# Development Rules
* Be sure to update /plan. For this task, create a folder named Issue-12.
* All documentation must be written in **Japanese** under the `docusaurus` directory.
* When updating Docusaurus, always update `/sidebars/` as well.
* Documentation must be written in **Japanese**!!
* Docusaurus markdown must include `id` and `title`.
* Use **Mermaid** for diagrams when necessary.
* KEEP TDD(test driven development)!!
* フロントエンド開発の場合は以下に留意すること
    - 実装プランはフェーズに分け、段階的に結果を確認しながら実装を進めること
    - 画面デザインについては、デザイン画像から判断できない点などは、適宜質問・確認しながら進めること
    - 実装順序としては、まずはWidgetbookにUIコンポーネントを作成してから、それを活用して画面構築を行うこと

# Detailed Design Structure
* Strictly follow TDD
* Strictly follow Atomic Design
* Strictly follow Onion Architecture

# Restrictions
* Do not cause Docusaurus MDX errors or Mermaid syntax errors.
* Do not build Docusaurus unless explicitly instructed.

