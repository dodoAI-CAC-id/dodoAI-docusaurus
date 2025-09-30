---
id: setup-mock-with-swagger
title: Setup Mock with Swagger
---

# Setup Mock with Swagger

## Instruction
Create a mock server based on Swagger definitions using Swagger Mock Library ( e.g. Nodejs Express).

## Overview
Develop a Swagger mock server to enable front-end development to proceed, even in the absence of actual backend APIs.

## Goals
- To simulate backend API responses for frontend integration testing.
- To facilitate parallel front-end and back-end development.

## Key Points
- Use Swagger definition files to outline expected API responses.
- If dodo lowcode or any similar existing mock server deployment service is available, leverage it to streamline the process.

## Sample
**Note: The sample provided below is intended as a template for setting up a mock server environment. Customize the content according to your specific Swagger API definitions.**

```javascript
// Mock Server Example Using Express and swagger-ui-express

const express = require('express');
const swaggerUi = require('swagger-ui-express');
const YAML = require('yamljs');

const app = express();
const swaggerDocument = YAML.load('./path/to/your/swagger.yaml');

app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerDocument));

// Define endpoint behavior based on Swagger definitions
app.get('/api/<endpoint>', (req, res) => {
  // Respond with the mock data as defined in Swagger
  res.json({ message: 'This is a mocked response' });
});

// More endpoints...

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Mock server running on port ${PORT}`);
});
```