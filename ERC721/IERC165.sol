// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

interface IERC165 {
    /**
     *  IERC165接口是用来验证合约是否实现了某一特定的接口，允许合约检查其他合约是否实现了特定的接口。
     *  通常情况下 一个合约可以通过实现 IERC165 接口来使其它合约能够检查它是否支持某些特定的功能或标准。
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}