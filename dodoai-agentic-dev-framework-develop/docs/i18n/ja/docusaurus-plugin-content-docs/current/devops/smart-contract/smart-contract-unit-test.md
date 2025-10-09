---
id: smart-contract-unit-test
title: スマートコントラクト単体テスト
---

# スマートコントラクト単体テスト

## 概要

スマートコントラクトの単体テストは、コントラクトが期待通りに動作し、信頼性があることを確認するために作成されます。

### 入力

- スマートコントラクト
- サンプルプロンプト (**request_id**): b01a0017-c715-410d-82be-d77ee16bf8d6

### 出力

- スマートコントラクト単体テスト

## サンプルコード

以下は、`StickerNFT` スマートコントラクトに対する単体テストのサンプルです。Hardhat と Chai を使用しています。

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
    // コントラクトファクトリーとサインナーを取得
    const StickerNFT = await ethers.getContractFactory("StickerNFT");
    [owner, addr1, addr2, ...addrs] = await ethers.getSigners();
    
    // コントラクトをデプロイ
    maxSupply = 10;
    stickerNFT = await upgrades.deployProxy(StickerNFT, [maxSupply], { initializer: 'initialize' });
  });

  describe("デプロイ", function () {
    it("maxSupply が正しく設定されること", async function () {
      expect(await stickerNFT.maxSupply()).to.equal(maxSupply);
    });

    it("コントラクトのオーナーが正しく設定されること", async function () {
      expect(await stickerNFT.owner()).to.equal(owner.address);
    });
  });

  describe("ミント機能", function () {
    it("新しいトークンをミントし、イベントを発行すること", async function () {
      const tokenId = BigNumber.from("1");
      await expect(stickerNFT.mint(addr1.address, tokenId, "tokenURI"))
        .to.emit(stickerNFT, "Minted")
        .withArgs(addr1.address, tokenId, "tokenURI");
      expect(await stickerNFT.ownerOf(tokenId)).to.equal(addr1.address);
    });

    it("最大供給数に達した場合、ミントに失敗すること", async function () {
      const tokenId = BigNumber.from("1");
      for (let i = 0; i < maxSupply; i++) {
        await stickerNFT.mint(addr1.address, tokenId.add(i), `tokenURI${i}`);
      }
      await expect(stickerNFT.mint(addr1.address, tokenId.add(maxSupply), "extraTokenURI"))
        .to.be.revertedWith("Max supply reached");
    });
  });
});
