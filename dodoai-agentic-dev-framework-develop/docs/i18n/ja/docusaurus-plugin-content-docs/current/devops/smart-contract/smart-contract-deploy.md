---
id: smart-contract-deploy
title: スマートコントラクトのデプロイ
---

## スマートコントラクトのデプロイ

## 概要

スマートコントラクトのデプロイとは、コントラクトのコードをブロックチェーンネットワークにプッシュし、ユーザーが実行・操作できるようにするプロセスです。このプロセスには、コントラクトの正しい動作、安全性の確保、ブロックチェーンのルールへの準拠を確保するための明確な手順が含まれます。

## 手順

### 1. スマートコントラクトデプロイの準備

1. **デプロイ設定の記述:** デプロイ先ネットワーク、Solidity バージョン、ファイルパスなどを設定する。
2. **デプロイロジックの実装:** デプロイリクエストの処理、バージョン管理、セキュリティチェックを行うコードを記述する。
3. **セキュリティ監査:** コントラクトの安全性を確認するための監査を実施する。

#### 設定ファイルの例

`hardhat.config.js`:

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

### 2. 環境の準備

```plaintext
NETWORK_RPC=<your_network_rpc_url>
NETWORK_CHAIN_ID=<your_chain_id>
ADMIN_PRIVATE_KEY=<your_admin_private_key>
ADMIN_KMS_ID=<your_kms_key_id>
STICKER_NFT_MAX_SUPPLY=<max_supply_of_nft>
STICKER_NFT_NAME=<name_of_nft>
STICKER_NFT_SYMBOL=<symbol_of_nft>
```

### 3. テストネットへのデプロイ

1. **テストネットの選択:** **Shibuya** を選択  
2. **ETH の取得:** デプロイ費用をカバーするために、テストネットのファーセットから ETH を取得  
3. **コントラクトのコンパイル:** Hardhat を使用してデプロイ用のスマートコントラクトをコンパイル  

```sh
npx hardhat compile
```

4. **スマートコントラクトのデプロイ**

```sh   
npx hardhat run scripts/deploy.js --network shibuya
```

5. デプロイの確認: スマートコントラクトが正常にテストネットへデプロイされ、期待通り機能することを確認

### 3. メインネットへのデプロイ

1. **メインネット準備:** スマートコントラクトのコードが完全に監査され、テストネットで十分にテストされていることを確認  
2. **メインネットの選択:** **Astar** を選択  
3. **メインネットのETH:** メインネットのウォレットに十分なガス料金分のETHがあることを確認  
4. **コントラクトのコンパイル:** メインネット用にスマートコントラクトをコンパイル  

```sh
npx hardhat compile
```

5. **デプロイメントスマートコントラクトのデプロイ:**

```sh
npx hardhat run scripts/deploy.js --network astar_kms
```

6. **エンティティの登録:** 契約をデプロイおよび管理できる許可されたアドレスを追加します。

7. **検証とログ記録:**
   - トランザクションのレシートと新しくデプロイされたコントラクトのアドレスを確認して、デプロイを確認します。
   - 監査目的のために、関連するすべての詳細が記録され、保存されていることを確認します。

### 4. デプロイ後の検証

1. **機能チェック:** デプロイされたコントラクトが意図したとおりに動作することを確認します。  
2. **セキュリティ監査:** デプロイ後のセキュリティ監査を実施し、脆弱性がないことを確認します。  
3. **バージョン管理:** デプロイされたコントラクトのバージョンにタグを付け、必要に応じてバージョン記録を更新します。  
