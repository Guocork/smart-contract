// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;


import "../ERC721/ERC721.sol";
import "./MerkleProof.sol";


contract MerkleTree is ERC721 {

    // 设置跟hash
    /**
        solidity中 bytes string 区别
        string类型用于处理Unicode字符串，bytes和byte[]类型用于处理二进制数据。需要根据实际需求来选择合适的类型。
        1. bytes 类型：当你将一个字符串赋值给 bytes 类型的变量时，它会直接存储字符串的原始字节序列，而不会对字符串进行任何编码。
        所以如果你将一个 ASCII 编码的字符串赋给 bytes 类型的变量，它会以原始的 ASCII 字节序列存储；
        如果你将一个 UTF-8 编码的字符串赋给 bytes 类型的变量，它会以原始的 UTF-8 字节序列存储。
        2. string 类型：存储的是经过 UTF-8 编码的字符串。当你将一个字符串赋值给 string 类型的变量时，Solidity 会自动将字符串编码为 UTF-8，
        并存储 UTF-8 编码的字节序列。因此，无论字符串是 ASCII 编码还是 UTF-8 编码，存储到 string 类型的变量中时都会以 UTF-8 编码形式存储。
        3. 操作 bytes 类型的变量通常比操作 string 类型的变量消耗更少的 gas
     */
    bytes32 immutable public root; // 这里有个小问题 为什么字节类型数据可以声明immutable？

    // 记录地址是否已经铸造
    mapping(address => bool) public mintedAddress;

    // 构造器 初始化 根hash
    constructor(string memory name, string memory symbol, bytes32 merkleroot) ERC721(name, symbol) {
        root = merkleroot;
    }

    // 进行铸造
    function mint(address account, uint256 tokenId, bytes32[] calldata proof) external {

        // 这里判断该地址是否在白名单中
        require(_verify(_leaf(account),proof),"Invalid merkle proof");

        // 这里判断该地址是否已经铸造
        require(!mintedAddress[account],"Already minted!");

        // 进行铸造
        _mint(account, tokenId);

        // 更改状态 记录该地址已经铸造
        mintedAddress[account] = true;
    }

    // 封装函数计算该地址的hash值 即叶子的hash
    function _leaf(address account) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked(account));
    }

    // 封装调用验证方法 看这个地址是否在白名单中
    function _verify(bytes32 leaf, bytes32[] memory proof) internal view returns (bool) {
        return MerkleProof.verify(proof, root, leaf);
    }

}