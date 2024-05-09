// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;


/**
    IERC721Metadata是ERC721的拓展接口，实现了3个查询metadata元数据的常用函数
 */
interface IERC721Metadata is IERC721 {

    // 返回代币名称
    function name() external view returns (string memory);

    // 返回代币代号
    function symbol() external view returns (string memory);

    // 通过tokenId查询metadata的链接url，ERC721特有的函数。
    function tokenURI(uint256 tokenId) external view returns (string memory);
}