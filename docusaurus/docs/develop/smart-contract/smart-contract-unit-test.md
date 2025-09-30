---
id: smart-contract-unit-test
title: Smart Contract Unit Test
---

# Smart Contract Unit Test

## Overview

Smart Contract Unit Tests are generated from the Smart Contract to ensure that the contract functions as expected and are reliable.

### Inputs

- Smart Contract
- Sample Prompt (**request_id**): b01a0017-c715-410d-82be-d77ee16bf8d6

### Output

- Smart Contract Unit Test

## Sample Code

Below is an example of a unit test for the `StickerNFT` smart contract using Hardhat and Chai.

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
    // Get the ContractFactory and Signers here.
    const StickerNFT = await ethers.getContractFactory("StickerNFT");
    [owner, addr1, addr2, ...addrs] = await ethers.getSigners();
    
    // Deploy the contract
    maxSupply = 10;
    stickerNFT = await upgrades.deployProxy(StickerNFT, [maxSupply], { initializer: 'initialize' });
  });

  describe("Deployment", function () {
    it("should set the right maxSupply", async function () {
      expect(await stickerNFT.maxSupply()).to.equal(maxSupply);
    });

    it("should set the right owner", async function () {
      expect(await stickerNFT.owner()).to.equal(owner.address);
    });
  });

  describe("Minting", function () {
    it("should mint a new token and emit an event", async function () {
      const tokenId = BigNumber.from("1");
      await expect(stickerNFT.mint(addr1.address, tokenId, "tokenURI"))
        .to.emit(stickerNFT, "Minted")
        .withArgs(addr1.address, tokenId, "tokenURI");
      expect(await stickerNFT.ownerOf(tokenId)).to.equal(addr1.address);
    });

    it("should fail to mint if max supply is reached", async function () {
      const tokenId = BigNumber.from("1");
      for (let i = 0; i < maxSupply; i++) {
        await stickerNFT.mint(addr1.address, tokenId.add(i), `tokenURI${i}`);
      }
      await expect(stickerNFT.mint(addr1.address, tokenId.add(maxSupply), "extraTokenURI"))
        .to.be.revertedWith("Max supply reached");
    });
  });
});