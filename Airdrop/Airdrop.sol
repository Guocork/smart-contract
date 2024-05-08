/**
    这是一个空投合约 这个合约是个i代笔发行方 或者 项目方用的 msg.sender 代表的是项目方
 */

// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import "../ERC20/IERC20.sol";

contract Airdrop {

    // 这里封装了一个求和函数 下面两个业务代码中重复出现
    /**
        引用类型做参数要指明存储位置：
        1. memory，当参数是内部函数调用的一部分，或者是内部函数的局部变量时
        2. calldata，当参数是外部函数调用时的传入数据时。
        3. storage，当参数是状态变量时（通常不适用于函数参数，但可能用于函数返回值）。
        一般函数参数中的引用类型使用calldata
     */
    function getSum(uint256[] calldata _arr) public pure returns(uint sum) {
        for (uint i = 0; i < _arr.length; i++) {
            sum = sum + _arr[i];
        }
    }

    // 下面是两种不同的方法进行空投 一种是进行授权投放 一种是转账投放
    // 发送ERC20 代币
    function multiTransferToken(
        address _token,  // 转账的ERC20代币地址
        address[] calldata _addresses,  // 要发送(空投)的地址集合
        uint256[] calldata _amounts    // 每个地址对应的空头数量
        ) external {
            // 判断发送的地址与发送的数量相同 确保每一个地址都有对应的空投
            require(_addresses.length == _amounts.length,"Lengths of Addresses and Amounts NOT EQUAL");

            // 实例化ERC20代币
            IERC20 token = IERC20(_token);

            // 计算需要发送的空头代币的数量总额
            uint _amountSum = getSum(_amounts);

            // 授权发送的代币数量 >= 空投的代币数量 这里项目方不需要向合约中转如代币 只需要给合约授权就可以
            require(token.allowance(msg.sender, address(this)) >= _amountSum,"Need Approve ERC20 token");

            // for循环，利用transferFrom函数发送空投 
            // 注意这里调用token里的transfFrom函数的时候 减少的是这个空投合约被授权的代币数量 即token合约里transfFrom
            // 里的msg.sender是 address(this) 是这个Airdrop合约的地址
            for (uint8 i = 0; i < _addresses.length; i++) {
                token.transferFrom(msg.sender, _addresses[i], _amounts[i]);
            }
        }


    // 发送ETH 空投 向多个地址转账ETH
    /**
        1. payable 关键字：表示这个函数可以接受或者发送以太币作为函数的一部分
        2. pubulic 关键字：函数可以被其他合约或合约内部的其他函数调用
        3. external 关键字：函数只能被其他合约调用，而不能被合约内部的其他函数调用，使用external 关键字可以稍微降低 gas 消耗
     */
    function multiTransferETH(
        address payable[] calldata _addresses, // 接受空投地址集合 这里使用payable 关键字修饰 证明这个地址可以接受以太币
        uint256[] calldata _amounts            // 给每个地址投递的空头数量
    ) public payable {

        // 判断地址与空头数量是否相等
        require(_addresses.length == _amounts.length, "Lengths of Addresses and Amounts NOT EQUAL");

        // 计算所虚的空投总量
        uint _amountSum = getSum(_amounts);
        
        // 注意 这里的msg.value 不是智能合约里存储的以太币数量 而是 在交易中转入合约内的以太币数量
        /**
            msg.value是一个全局变量，它表示一个以太币交易中所发送的以太币数量。以太币是以太坊区块链的本地货币，因此msg.value用于检查当前智能合约是否接收到了足够的以太币。
            msg.value可以在智能合约中用于以下情况：
            1. 确定智能合约已经收到足够的以太币进行操作。
            2. 把接收到的以太币转发到其他账户，例如把以太币存入合约中并分配到不同的地址。
            需要注意的是，msg.value只能在以太币交易中使用，不能在调用合约的函数中使用。
         */
        // 判断转入的以太币数量是否等于分配的以太总数
        require(msg.value == _amountSum, "Transfer amount error");

        // for循环，利用transfer函数发送ETH
        /**
            注意：这里的transfer方法不是ERC20 接口实现的方法 这个是solidity中所有地址类型内置的成员函数
            所有地址类型可以调用transfer(amount) 方法向这个地址中转入对应的代币 因为这里的地址被payable 修饰 所以这些地址可以接受以太币
         */
        for (uint256 i = 0; i < _addresses.length; i++) {
            _addresses[i].transfer(_amounts[i]);
        }
    }
}
/**
    小tips：
    不过需要注意的是，如果发送以太币的地址没有足够的余额，或者目标地址不接受以太币（没有实现 receive 函数或者 payable 关键字修饰），
    那么 transfer 方法会抛出异常，导致交易失败。
    所以，无论地址是否使用 payable 关键字修饰，都可以调用 transfer 方法来发送以太币。
    但是，只有使用 payable 关键字修饰的地址才能够接收以太币。
 */
