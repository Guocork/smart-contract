// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;


import "../ERC721/ERC721.sol";
import "./MerkleProof.sol";


contract MerkleTree is ERC721 {
    bytes32 immutable public root; // 这里有个小问题 为什么字节类型数据可以声明immutable？

    mapping(address => bool) public mintedAddress;

    constructor(string memory name, string memory symbol, bytes32 merkleroot) ERC721(name, symbol) {
        root = merkleroot;
    }

    function mint(address account, uint256 tokenId, bytes32[] calldata proof) external {
        require(_verify(_leaf(account),proof),"Invalid merkle proof");
        require(!mintedAddress[account],"Already minted!");

        _mint(account, tokenId);
        mintedAddress[account] = true;
    }

    function _leaf(address account) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked(account));
    }

    function _verify(bytes32 leaf, bytes32[] memory proof) internal view returns (bool) {
        return MerkleProof.verify(proof, root, leaf);
    }

}