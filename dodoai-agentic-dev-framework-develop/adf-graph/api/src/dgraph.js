const dgraph = require('dgraph-js');
const grpc = require('@grpc/grpc-js');

function createDgraphClient() {
  const clientStub = new dgraph.DgraphClientStub(
    process.env.DGRAPH_ALPHA_URL || 'localhost:9080',
    grpc.credentials.createInsecure()
  );
  
  return new dgraph.DgraphClient(clientStub);
}

module.exports = { createDgraphClient };
