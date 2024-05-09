// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

abstract contract Context {

    /**
        virtual 关键字，表示它可以在子合约中被重写
     */
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    // 返回函数的参数信息
    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }


    /**
        知识点：
        1. msg.data 全局变量 用来存储当前函数的调用数据 也就是函数调用时候传入的参数
        2. 在以太坊智能合约中，当一个函数被调用时，调用方可以传递参数给该函数。
           这些参数会被打包成一个字节数组，并作为 msg.data 的一部分传递给被调用的函数。
           这个字节数组中包含了函数的签名和参数数据，可以通过解析 msg.data 来获取函数调用时传递的参数值。
        3. msg.data 结构如下：
             （1）前四个字节（32 位）表示函数的签名（函数选择器），用于唯一标识函数。
             （2）剩余的字节表示函数的参数数据。 
        4. msg.data 是包含了函数调用参数和数据一个字节数组 所以使用calldata标明存储位置
     */
}