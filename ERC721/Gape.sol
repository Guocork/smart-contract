// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import "./ERC721.sol";

contract Gape is ERC721 {
    uint public MAX_APES = 10000; 

    constructor(string memory name_, string memory symbol_) ERC721(name_, symbol_) {}

    function _baseURI() internal pure override returns(string memory) {
        return "ipfs://QmeSjSinHpPnmXmspMjwiXyN6zS4E9zccariGR3jxcaWtq/";
    }

    function mint(address to, uint tokenId) external {
        require(tokenId >= 0 && tokenId < MAX_APES, "tokenId out of range");
        _mint(to, tokenId);
    }
}
