const dgraph = require('dgraph-js');
const grpc = require('@grpc/grpc-js');

async function seedData() {
  const clientStub = new dgraph.DgraphClientStub(
    'localhost:9080',
    grpc.credentials.createInsecure()
  );
  
  const dgraphClient = new dgraph.DgraphClient(clientStub);

  const schema = `
    name: string @index(term) .
    description: string .
    createdAt: datetime .
    updatedAt: datetime .
    category: string @index(exact) .
    content: string @index(fulltext) .
    project: [uid] @reverse .
    task: [uid] @reverse .
    templates: [uid] @reverse .
  `;

  const op = new dgraph.Operation();
  op.setSchema(schema);
  await dgraphClient.alter(op);

  const now = new Date().toISOString();

  const sampleData = {
    projects: [
      {
        uid: '_:project1',
        'dgraph.type': 'Project',
        name: 'E-commerce Platform',
        description: 'Modern e-commerce platform with React and Node.js',
        createdAt: now,
        updatedAt: now,
      },
      {
        uid: '_:project2',
        'dgraph.type': 'Project',
        name: 'DeFi Protocol',
        description: 'Decentralized finance protocol with smart contracts',
        createdAt: now,
        updatedAt: now,
      }
    ],
    tasks: [
      {
        uid: '_:task1',
        'dgraph.type': 'Task',
        name: 'User Authentication',
        category: 'API',
        project: { uid: '_:project1' },
        createdAt: now,
        updatedAt: now,
      },
      {
        uid: '_:task2',
        'dgraph.type': 'Task',
        name: 'Product Catalog UI',
        category: 'FRONTEND',
        project: { uid: '_:project1' },
        createdAt: now,
        updatedAt: now,
      },
      {
        uid: '_:task3',
        'dgraph.type': 'Task',
        name: 'Token Contract',
        category: 'SMARTCONTRACT',
        project: { uid: '_:project2' },
        createdAt: now,
        updatedAt: now,
      }
    ],
    templates: [
      {
        uid: '_:template1',
        'dgraph.type': 'Template',
        name: 'JWT Authentication Middleware',
        content: `const jwt = require('jsonwebtoken');

const authenticateToken = (req, res, next) => {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];

  if (!token) {
    return res.sendStatus(401);
  }

  jwt.verify(token, process.env.ACCESS_TOKEN_SECRET, (err, user) => {
    if (err) return res.sendStatus(403);
    req.user = user;
    next();
  });
};

module.exports = authenticateToken;`,
        task: { uid: '_:task1' },
        createdAt: now,
        updatedAt: now,
      },
      {
        uid: '_:template2',
        'dgraph.type': 'Template',
        name: 'Product Card Component',
        content: `import React from 'react';

interface ProductCardProps {
  product: {
    id: string;
    name: string;
    price: number;
    image: string;
    description: string;
  };
  onAddToCart: (productId: string) => void;
}

export const ProductCard: React.FC<ProductCardProps> = ({ product, onAddToCart }) => {
  return (
    <div className="bg-white rounded-lg shadow-md overflow-hidden">
      <img src={product.image} alt={product.name} className="w-full h-48 object-cover" />
      <div className="p-4">
        <h3 className="text-lg font-semibold mb-2">{product.name}</h3>
        <p className="text-gray-600 mb-4">{product.description}</p>
        <div className="flex justify-between items-center">
          <span className="text-xl font-bold">\${product.price}</span>
          <button
            onClick={() => onAddToCart(product.id)}
            className="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600"
          >
            Add to Cart
          </button>
        </div>
      </div>
    </div>
  );
};`,
        task: { uid: '_:task2' },
        createdAt: now,
        updatedAt: now,
      },
      {
        uid: '_:template3',
        'dgraph.type': 'Template',
        name: 'ERC20 Token Contract',
        content: `// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyToken is ERC20, Ownable {
    constructor(
        string memory name,
        string memory symbol,
        uint256 initialSupply
    ) ERC20(name, symbol) {
        _mint(msg.sender, initialSupply * 10**decimals());
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function burn(uint256 amount) public {
        _burn(msg.sender, amount);
    }
}`,
        task: { uid: '_:task3' },
        createdAt: now,
        updatedAt: now,
      }
    ]
  };

  const txn = dgraphClient.newTxn();
  try {
    const allData = [
      ...sampleData.projects,
      ...sampleData.tasks,
      ...sampleData.templates
    ];
    
    const mutation = new dgraph.Mutation();
    mutation.setSetJson(allData);
    
    await txn.mutate(mutation);
    await txn.commit();
    console.log('Sample data seeded successfully!');
  } catch (error) {
    console.error('Error seeding data:', error);
  } finally {
    await txn.discard();
  }

  clientStub.close();
}

if (require.main === module) {
  seedData().catch(console.error);
}

module.exports = { seedData };
