// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

// 这里封装了toString() 方法
library Strings {

    function toString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        
        // 这里用来计算value的位数 数字的个数 通过不断的除10 来进行计算
        while (temp != 0) {
            digits++;
            temp /= 10;
        }

        // 声明动态字节数组buffer 这里是动态数组的初始化 详细看这里：https://www.whatsweb3.org/docs/solidity-basic/array
        bytes memory buffer = new bytes(digits);

        while (value != 0) {
            digits -= 1;
            // 这里转换value 每个数字成 ASCII 码的值存储到 buffer 的相应位置
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }

        return string(buffer);
    }
}