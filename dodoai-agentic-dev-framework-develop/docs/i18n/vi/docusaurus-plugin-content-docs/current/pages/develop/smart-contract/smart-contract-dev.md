---
id: smart-contract-dev
title: Phát Triển Hợp Đồng Thông Minh
---

## Tổng Quan

Phát triển hợp đồng thông minh được tạo ra từ Đặc Tả Hợp Đồng Thông Minh để triển khai logic nghiệp vụ và đảm bảo nó hoạt động như dự kiến trên blockchain.

### Đầu Vào

- Hướng Dẫn
- Đặc Tả Hợp Đồng Thông Minh
- Ví Dụ Đề Xuất: https://58llm.link/main/restore/10126895-4240-4633-9084-0a94350152a2

### Đầu Ra

- Hợp Đồng Thông Minh

## Mã Mẫu

Dưới đây là một ví dụ về hợp đồng thông minh được phát triển dựa trên các đặc tả đã cung cấp.

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

    // Override required by Solidity for upgradable contracts.
    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}
    
    // Các hàm sau đây là các ghi đè được yêu cầu bởi Solidity.
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
```
