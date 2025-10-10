---
id: smart-contract-dev
title: スマートコントラクト開発
---

# スマートコントラクト開発

## 概要

スマートコントラクトの開発は、スマートコントラクト仕様に基づいてビジネスロジックを実装し、ブロックチェーン上で期待どおりに動作することを保証するプロセスです。

### 入力

- 指示  
- スマートコントラクト仕様  
- サンプルプロンプト: [https://58llm.link/main/restore/10126895-4240-4633-9084-0a94350152a2](https://58llm.link/main/restore/10126895-4240-4633-9084-0a94350152a2)  

### 出力

- スマートコントラクト  

## サンプルコード

以下は、提供された仕様に基づいて開発されたスマートコントラクトの例です。

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721URIStorageUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

contract StickerNFT is Initializable, ERC721Upgradeable, ERC721URIStorageUpgradeable, ERC721EnumerableUpgradeable, OwnableUpgradeable, UUPSUpgradeable {
    uint256 public maxSupply;
    mapping(address => bool) public whitelist;

    event Minted(address indexed to, uint256 indexed tokenId, string tokenUri);
    event WhitelistUpdated(address indexed account, bool isAdded);

    function initialize(string memory name_, string memory symbol_, uint256 maxSupply_) public initializer {
        __ERC721_init(name_, symbol_);
        __ERC721URIStorage_init();
        __ERC721Enumerable_init();
        __Ownable_init();
        __UUPSUpgradeable_init();
        maxSupply = maxSupply_;
    }

    function mint(address to, uint256 tokenId, string memory tokenUri) public onlyOwner {
        require(totalSupply() < maxSupply, "Max supply reached");
        require(!_exists(tokenId), "Token ID already exists");

        _safeMint(to, tokenId);
        _setTokenURI(tokenId, tokenUri);
        emit Minted(to, tokenId, tokenUri);
    }

    function addToWhitelist(address account) public onlyOwner {
        whitelist[account] = true;
        emit WhitelistUpdated(account, true);
    }

    function removeFromWhitelist(address account) public onlyOwner {
        whitelist[account] = false;
        emit WhitelistUpdated(account, false);
    }

    // Solidityの要件により、アップグレード可能なコントラクトのオーバーライド
    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}

    // Solidityの要件により、以下の関数をオーバーライド
    function _burn(uint256 tokenId) internal override(ERC721Upgradeable, ERC721URIStorageUpgradeable) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId) public view override(ERC721Upgradeable, ERC721URIStorageUpgradeable) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId) public view override(ERC721Upgradeable, ERC721EnumerableUpgradeable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
