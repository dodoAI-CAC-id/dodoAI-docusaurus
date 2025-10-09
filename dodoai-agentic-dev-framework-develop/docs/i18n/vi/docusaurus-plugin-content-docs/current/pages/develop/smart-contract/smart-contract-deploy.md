---
id: smart-contract-deploy
title: Triển Khai Hợp Đồng Thông Minh
---

## Tổng Quan

Triển khai hợp đồng thông minh là quá trình đẩy mã của hợp đồng lên mạng blockchain để có thể được thực thi và tương tác bởi người dùng. Quá trình này thường bao gồm nhiều bước được định nghĩa rõ ràng để đảm bảo hợp đồng hoạt động như dự định, có tính bảo mật và tuân thủ các quy tắc của blockchain.

## Các Bước

### 1. Chuẩn Bị Triển Khai Hợp Đồng Thông Minh

1. **Viết Cấu Hình Triển Khai:** Định cấu hình trong Hợp Đồng Thông Minh Triển Khai để xử lý mạng triển khai, solidity, đường dẫn tệp, ...
2. **Viết Logic Triển Khai:** Thực hiện logic trong Hợp Đồng Thông Minh Triển Khai để xử lý các yêu cầu triển khai, quản lý phiên bản, và kiểm tra bảo mật.
3. **Kiểm Tra Bảo Mật:** Thực hiện kiểm tra bảo mật để đảm bảo Hợp Đồng Thông Minh Triển Khai an toàn.

#### Dưới Đây Là Ví Dụ

Tệp hardhat.config.js

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

Tệp scripts/deploy.js

```javascript
const hre = require("hardhat");
const ethers = hre.ethers;

let envFileName = "./.env";

require("dotenv").config({ path: envFileName });
const config = process.env;

const main = async () => {
  // khóa riêng của ví quản trị
  const accounts = await hre.ethers.getSigners();
  const adminWalletAddress = accounts[0].address;
  console.log("Địa chỉ ví quản trị: " + adminWalletAddress);
  // triển khai NFT
  const maxSupply = config.STICKER_NFT_MAX_SUPPLY;
  // chỉ dành cho kiểm thử
  const name = config.STICKER_NFT_NAME;
  const symbol = config.STICKER_NFT_SYMBOL;

  const StickerNFT = await ethers.getContractFactory("StickerNFT");
  const stickerNft = await upgrades.deployProxy(StickerNFT, [
    name,
    symbol,
    maxSupply,
  ]);
  await stickerNft.deployed();

  console.log(`Địa chỉ Sticker NFT: ${stickerNft.address.toLowerCase()}`);
};

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
```

### 2. Chuẩn Bị Môi Trường

```plaintext
NETWORK_RPC=<địa chỉ_mạng_rpc_của_bạn>
NETWORK_CHAIN_ID=<id_chain_của_bạn>
ADMIN_PRIVATE_KEY=<khóa_riêng_quản_trị_của_bạn>
ADMIN_KMS_ID=<id_kms_của_bạn>
STICKER_NFT_MAX_SUPPLY=<tổng_cung_nft_tối_đa>
STICKER_NFT_NAME=<tên_nft>
STICKER_NFT_SYMBOL=<kí_hiệu_nft>
```

### 2. Triển Khai Trên Testnet

1. **Chọn Testnet:** Chọn một testnet: **Shibuya**
2. **Nhận Ethereum Testnet:** Nhận một lượng ETH testnet từ faucet để trang trải chi phí triển khai.
3. **Biên Dịch Hợp Đồng:** Biên dịch Hợp Đồng Thông Minh Triển Khai sử dụng Hardhat.

```sh
npx hardhat compile
```

4. **Triển Khai Hợp Đồng Thông Minh Triển Khai:**

```sh
npx hardhat run scripts/deploy.js --network shibuya
```

5. **Xác Minh Triển Khai:** Đảm bảo rằng hợp đồng được triển khai thành công trên testnet và hoạt động đúng.

### 3. Triển Khai Trên Mainnet

1. **Chuẩn Bị Mainnet:** Đảm bảo mã hợp đồng thông minh được kiểm tra bảo mật hoàn toàn và thử nghiệm trên testnet.
2. **Chọn Mainnet:** Chọn một testnet: **Astar**
3. **ETH Mainnet:** Đảm bảo rằng bạn có đủ ETH để trả phí gas trong ví mainnet của bạn.
4. **Biên Dịch Hợp Đồng:** Biên dịch Hợp Đồng Thông Minh Triển Khai cho mainnet.

```sh
npx hardhat compile
```

5. **Triển Khai Hợp Đồng Thông Minh Triển Khai:**

```sh
npx hardhat run scripts/deploy.js --network astar_kms
```

6. **Đăng Ký Thực Thể:** Thêm các địa chỉ được ủy quyền có thể triển khai và quản lý hợp đồng.

7. **Xác Minh và Ghi Lại:**
   - Xác nhận việc triển khai bằng cách kiểm tra biên nhận giao dịch và địa chỉ hợp đồng mới được triển khai.
   - Đảm bảo rằng tất cả các chi tiết liên quan được ghi lại và lưu trữ để phục vụ kiểm toán.

### 4. Xác Minh Sau Triển Khai

1. **Kiểm Tra Chức Năng:** Xác minh rằng hợp đồng được triển khai hoạt động như dự định.
2. **Kiểm Tra Bảo Mật:** Thực hiện kiểm tra bảo mật sau triển khai để đảm bảo không có lỗ hổng.
3. **Quản Lý Phiên Bản:** Gắn thẻ phiên bản hợp đồng đã triển khai và cập nhật bất kỳ hồ sơ phiên bản nào khi cần thiết.
