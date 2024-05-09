/**
    这里是对使用ERC721 写了一个铸造Gape nft的合约实践 代表了一个名为 "Gape" 的 NFT（非同质化代币）系列
 */


// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import "./ERC721.sol";

contract Gape is ERC721 {
    uint public MAX_APES = 10000; 

    /**
        这里是合约继承构造器的一种写法 继承父合约中构造器的写法 通过调用父合约的构造函数来初始化继承的属性和状态。
     */
    constructor(string memory name_, string memory symbol_) ERC721(name_, symbol_) {}

    function _baseURI() internal pure override returns(string memory) {
        return "ipfs://QmeSjSinHpPnmXmspMjwiXyN6zS4E9zccariGR3jxcaWtq/";
    }

    function mint(address to, uint tokenId) external {
        require(tokenId >= 0 && tokenId < MAX_APES, "tokenId out of range");
        _mint(to, tokenId);
    }
}
