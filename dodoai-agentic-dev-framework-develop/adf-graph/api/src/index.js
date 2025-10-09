const express = require('express');
const { ApolloServer } = require('apollo-server-express');
const cors = require('cors');
require('dotenv').config();

const typeDefs = require('./schema');
const resolvers = require('./resolvers');
const { createDgraphClient } = require('./dgraph');

async function startServer() {
  const app = express();
  
  app.use(cors());
  
  const dgraphClient = createDgraphClient();
  
  const server = new ApolloServer({
    typeDefs,
    resolvers,
    context: () => ({
      dgraphClient,
    }),
  });

  await server.start();
  server.applyMiddleware({ app });

  const PORT = process.env.PORT || 4000;
  
  app.listen(PORT, '0.0.0.0', () => {
    console.log(`🚀 Server ready at http://localhost:${PORT}${server.graphqlPath}`);
  });
}

startServer().catch(error => {
  console.error('Error starting server:', error);
});
