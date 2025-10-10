# DodoAI Agentic Dev Framework

A comprehensive development framework for managing templates with Dgraph database and React frontend.

## Architecture

- **Frontend**: React + TypeScript + Vite with atomic design components
- **Backend**: GraphQL API with Apollo Server
- **Database**: Dgraph graph database for template relationships
- **Containerization**: Docker + Docker Compose

## Quick Start

### Prerequisites

- Docker and Docker Compose installed
- Node.js 18+ (for local development)

### 1. Start All Services

```bash
# Clone the repository
git clone https://github.com/58web3/dodoai-agentic-dev-framework.git
cd dodoai-agentic-dev-framework

# Start all services (Dgraph, GraphQL API, React frontend)
docker-compose up -d
```

### 2. Seed Sample Data

```bash
# Navigate to the graph directory and seed sample data
cd adf-graph
node seed-data.js
```

### 3. Access the Applications

- **Frontend (React UI)**: http://localhost:3000
- **GraphQL API**: http://localhost:4000/graphql
- **Dgraph Ratel (Database UI)**: http://localhost:8001

## Features

### Template Management
- Create, read, update, delete templates
- Organize templates by projects and tasks
- Category-based filtering (Design, API, Frontend, SmartContract, Other)
- Full-text search across template names and content

### Graph Visualization
- Interactive node visualization of template relationships
- Different node shapes for different entity types:
  - **Projects**: Blue circles
  - **Tasks**: Green squares  
  - **Templates**: Orange diamonds
- Zoom, pan, and node selection capabilities
- Real-time relationship mapping

### Sample Data Structure
The seeded data includes:
- **2 Projects**: E-commerce Platform, DeFi Protocol
- **3 Tasks**: User Authentication (API), Product Catalog UI (Frontend), Token Contract (SmartContract)
- **3 Templates**: JWT Authentication Middleware, Product Card Component, ERC20 Token Contract

## Development

### Local Development Setup

```bash
# Install dependencies for GraphQL API
cd adf-graph/api
npm install

# Install dependencies for React frontend
cd ../../frontend
npm install
```

### Running Services Individually

```bash
# Start Dgraph only
docker-compose up dgraph-zero dgraph-alpha dgraph-ratel -d

# Start GraphQL API (development mode)
cd adf-graph/api
npm run dev

# Start React frontend (development mode)
cd frontend
npm run dev
```

### Database Management

```bash
# Seed sample data
cd adf-graph
node seed-data.js

# Access Dgraph Ratel for database management
# Open http://localhost:8001 in your browser
```

## API Usage

### GraphQL Queries

```graphql
# Get all projects with tasks and templates
query GetGraphData {
  projects {
    id
    name
    description
    tasks {
      id
      name
      category
      templates {
        id
        name
        content
      }
    }
  }
}

# Search templates
query SearchTemplates($keyword: String!) {
  searchTemplates(keyword: $keyword) {
    id
    name
    content
    task {
      name
      project {
        name
      }
    }
  }
}
```

### GraphQL Mutations

```graphql
# Create a new template
mutation CreateTemplate($input: CreateTemplateInput!) {
  createTemplate(input: $input) {
    id
    name
    content
  }
}
```

## Directory Structure

```
├── adf-graph/                 # Dgraph database and GraphQL API
│   ├── api/                   # GraphQL API server
│   │   ├── src/
│   │   │   ├── index.js       # Server entry point
│   │   │   ├── schema.js      # GraphQL schema definition
│   │   │   ├── resolvers.js   # GraphQL resolvers
│   │   │   └── dgraph.js      # Dgraph client configuration
│   │   ├── package.json
│   │   └── Dockerfile
│   ├── docker-compose.yml     # Dgraph services
│   ├── schema.graphql         # GraphQL schema
│   └── seed-data.js          # Sample data seeding script
├── frontend/                  # React frontend application
│   ├── src/
│   │   ├── app/              # Application setup
│   │   ├── core/             # Core configurations
│   │   ├── features/         # Feature modules
│   │   ├── shared/           # Shared components (atomic design)
│   │   └── pages/            # Page components
│   ├── package.json
│   └── Dockerfile
├── docker-compose.yml         # Main orchestration file
└── README.md
```

## Troubleshooting

### Common Issues

1. **Port conflicts**: Ensure ports 3000, 4000, 8001, 9080, 5080 are available
2. **Docker issues**: Try `docker-compose down && docker-compose up -d`
3. **Data seeding fails**: Ensure Dgraph is running before running `node seed-data.js`
4. **GraphQL API connection issues**: Check that Dgraph Alpha is accessible at localhost:9080

### Logs

```bash
# View all service logs
docker-compose logs -f

# View specific service logs
docker-compose logs -f dgraph-alpha
docker-compose logs -f frontend
```

## Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-feature`
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is licensed under the MIT License.
