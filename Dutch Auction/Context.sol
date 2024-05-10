// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

abstract contract Context {

    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }

    // 这里是上一个例子中 Context合约中新增得部分 返回一个0
    function _contextSuffixLength() internal view virtual returns (uint256) {
        return 0;
    }
}