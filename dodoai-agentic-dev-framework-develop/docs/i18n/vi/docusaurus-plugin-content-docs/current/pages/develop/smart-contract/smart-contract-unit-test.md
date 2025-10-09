---
id: smart-contract-unit-test
title: Kiểm Thử Đơn Vị Hợp Đồng Thông Minh
---

## Tổng Quan

Kiểm thử đơn vị cho hợp đồng thông minh được tạo ra từ hợp đồng thông minh để đảm bảo rằng hợp đồng hoạt động như mong đợi và có độ tin cậy.

### Đầu Vào

- Hợp Đồng Thông Minh
- Ví Dụ Đề Xuất (**request_id**): b01a0017-c715-410d-82be-d77ee16bf8d6

### Đầu Ra

- Kiểm Thử Đơn Vị Hợp Đồng Thông Minh

## Mã Mẫu

Dưới đây là một ví dụ về kiểm thử đơn vị cho hợp đồng thông minh `StickerNFT` sử dụng Hardhat và Chai.

```javascript
const { expect } = require("chai");
const { ethers, upgrades } = require("hardhat");
const { BigNumber } = require("ethers");

describe("StickerNFT", function () {
  let stickerNFT;
  let maxSupply;
  let owner;
  let addr1;
  let addr2;
  let addrs;

  beforeEach(async function () {
    // Lấy ContractFactory và Signers ở đây.
    const StickerNFT = await ethers.getContractFactory("StickerNFT");
    [owner, addr1, addr2, ...addrs] = await ethers.getSigners();
    
    // Triển khai hợp đồng
    maxSupply = 10;
    stickerNFT = await upgrades.deployProxy(StickerNFT, [maxSupply], { initializer: 'initialize' });
  });

  describe("Triển Khai", function () {
    it("phải đặt đúng maxSupply", async function () {
      expect(await stickerNFT.maxSupply()).to.equal(maxSupply);
    });

    it("phải đặt đúng owner", async function () {
      expect(await stickerNFT.owner()).to.equal(owner.address);
    });
  });

  describe("Đúc", function () {
    it("phải đúc một token mới và phát ra sự kiện", async function () {
      const tokenId = BigNumber.from("1");
      await expect(stickerNFT.mint(addr1.address, tokenId, "tokenURI"))
        .to.emit(stickerNFT, "Minted")
        .withArgs(addr1.address, tokenId, "tokenURI");
      expect(await stickerNFT.ownerOf(tokenId)).to.equal(addr1.address);
    });

    it("phải thất bại khi đúc nếu đã đạt tới tổng cung tối đa", async function () {
      const tokenId = BigNumber.from("1");
      for (let i = 0; i < maxSupply; i++) {
        await stickerNFT.mint(addr1.address, tokenId.add(i), `tokenURI${i}`);
      }
      await expect(stickerNFT.mint(addr1.address, tokenId.add(maxSupply), "extraTokenURI"))
        .to.be.revertedWith("Max supply reached");
    });
  });
});
```
