---
id: smart-contract-deploy
title: Smart Contract Deployment
---

# Smart Contract Deployment

## Overview

Deploying a smart contract is the process of pushing a contract’s code to a blockchain network so that it can be executed and interacted with by users. This process typically involves several well-defined steps to ensure the contract operates as intended, remains secure, and adheres to the rules of the blockchain.

## Steps

### 1. Deployment Smart Contract Preparation

1. **Write Deployment Config:** Config in the Deployment Smart Contract for handling deployment networks, solidity, file paths, ...
2. **Write Deployment Logic:** Implement logic in the Deployment Smart Contract for handling deployment requests, versioning, and security checks.
3. **Audit Security:** Perform a security audit to ensure the Deployment Smart Contract is secure.

#### Here is an example

File hardhat.config.js

```javascript
require("@nomiclabs/hardhat-ethers");
require("@openzeppelin/hardhat-upgrades");
require("@nomiclabs/hardhat-web3");
require("@rumblefishdev/hardhat-kms-signer");

const { setTimeout } = require("timers/promises");

let envFileName = "./.env";

require("dotenv").config({ path: envFileName });
const config = process.env;

const AWS = require("aws-sdk");
AWS.config.update({ region: "ap-northeast-1" });

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  defaultNetwork: "localhost",
  networks: {
    localhost: {
      url: "http://localhost:8545",
      chainId: 31337,
    },
    shibuya: {
      url: config.NETWORK_RPC,
      chainId: parseInt(config.NETWORK_CHAIN_ID),
      accounts: config.ADMIN_PRIVATE_KEY ? [config.ADMIN_PRIVATE_KEY] : [],
    },
    shibuya_kms: {
      url: config.NETWORK_RPC,
      chainId: parseInt(config.NETWORK_CHAIN_ID),
      kmsKeyId: config.ADMIN_KMS_ID,
      gasPrice: 50000000000,
      gas: "auto",
      timeout: 200000,
    },
    astar_kms: {
      url: config.NETWORK_RPC,
      chainId: parseInt(config.NETWORK_CHAIN_ID),
      kmsKeyId: config.ADMIN_KMS_ID,
      gasPrice: 50000000000,
      gas: "auto",
      timeout: 200000,
    },
  },
  solidity: {
    compilers: [
      {
        version: "0.8.2",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          },
        },
      },
      {
        version: "0.8.1",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          },
        },
      },
    ],
  },
  paths: {
    sources: "./contracts",
    tests: "./test",
    cache: "./cache",
    artifacts: "./artifacts",
  },
  mocha: {
    timeout: 40000,
  },
};
```

File scripts/deploy.js

```javascript
const hre = require("hardhat");
const ethers = hre.ethers;

let envFileName = "./.env";

require("dotenv").config({ path: envFileName });
const config = process.env;

const main = async () => {
  // admin wallet private key
  const accounts = await hre.ethers.getSigners();
  const adminWalletAddress = accounts[0].address;
  console.log("admin wallet address: " + adminWalletAddress);
  // deploy NFT
  const maxSupply = config.STICKER_NFT_MAX_SUPPLY;
  // only for test
  const name = config.STICKER_NFT_NAME;
  const symbol = config.STICKER_NFT_SYMBOL;

  const StickerNFT = await ethers.getContractFactory("StickerNFT");
  const stickerNft = await upgrades.deployProxy(StickerNFT, [
    name,
    symbol,
    maxSupply,
  ]);
  await stickerNft.deployed();

  console.log(`Sticker NFT address: ${stickerNft.address.toLowerCase()}`);
};

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
```

### 2. Prepare Environment

```plaintext
NETWORK_RPC=<your_network_rpc_url>
NETWORK_CHAIN_ID=<your_chain_id>
ADMIN_PRIVATE_KEY=<your_admin_private_key>
ADMIN_KMS_ID=<your_kms_key_id>
STICKER_NFT_MAX_SUPPLY=<max_supply_of_nft>
STICKER_NFT_NAME=<name_of_nft>
STICKER_NFT_SYMBOL=<symbol_of_nft>
```

### 2. Deploying on Testnet

1. **Select Testnet:** Choose a testnet: **Shibuya**
2. **Faucet ETH:** Obtain some testnet ETH from a faucet to cover deployment costs.
3. **Compile Contract:** Compile the Deployment Smart Contract using Hardhat.

```sh
npx hardhat compile
```

4. **Deploy Deployment Smart Contract:**

```sh
npx hardhat run scripts/deploy.js --network shibuya
```

5. **Verify Deployment:** Ensure that the contract is deployed successfully on the testnet and functions correctly.

### 3. Deploying on Mainnet

1. **Mainnet Preparation:** Ensure the smart contract code is fully audited and tested on the testnet.
2. **Select Mainnet:** Choose a testnet: **Astar**
3. **Mainnet ETH:** Make sure to have sufficient ETH for gas fees in your mainnet wallet.
4. **Compile Contract:** Compile the Deployment Smart Contract for mainnet.

```sh
npx hardhat compile
```

5. **Deploy Deployment Smart Contract:**

```sh
npx hardhat run scripts/deploy.js --network astar_kms
```

6. **Register Entities:** Add authorized addresses that can deploy and manage contracts.

7. **Verification and Logging:**
   - Confirm the deployment by checking the transaction receipt and newly deployed contract address.
   - Ensure all relevant details are logged and stored for auditing purposes.

### 4. Post-Deployment Verification

1. **Functionality Check:** Verify that the deployed contract works as intended.
2. **Security Audit:** Perform a post-deployment security audit to ensure no vulnerabilities.
3. **Version Control:** Tag the deployed contract version and update any versioning records as necessary.
