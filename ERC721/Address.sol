// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

library Address {
    /**
        internal 关键字：表示只能在当前合约内部或继承的合约中调用该函数
     */
    // 这个函数用来判断 地址是否为合约地址
    function isContract(address account) internal view returns (bool) {
        return account.code.length > 0;
    }

    /**
        知识点：
        以太坊中智能合约的地址与普通账户的地址有区别
        1. 智能合约地址：具有关联的字节码，存储在合约地址的 code 属性中。当调用智能合约时，EVM（以太坊虚拟机）会执行这些字节码。
        2. 普通以太坊账户地址：不具有关联的字节码，其 code 属性长度为 0。这些地址用于存储以太币或其他代币，以及执行普通的以太坊交易。

        所以上面可以通过address的code属性来判断此地址是否为合约地址    
     */
}
