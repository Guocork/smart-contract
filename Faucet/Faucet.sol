/**
    这是一个水龙头合约
*/

// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import "../ERC20/IERC20.sol";

contract Faucet {

    // 每次领取 100 单位代币
    uint256 public amountAllowed = 100; 

    // token合约的地址
    address public tokenContract;     

    // 记录过领取过代的地址
    mapping( address => bool ) public requestedAddress; 

    // 定义一个事件记录每次领取代币的地址和数量
    event SendToken(address indexed receiver,uint indexed amount); // solidity对于每个事件最多支持3个索引

    // 部署时候设定ERC20 合约
    constructor(address _tokenContract) {
        tokenContract = _tokenContract;
    }

    // 用户调用这个函数领取代币 msg.sender是一个上下文的内嵌条件 不同用户输入 用户调用即是msg.sender
    /**
        solidity 中有三种事务回滚的关键字
        1. revert: 语句在遇到错误或者条件不满足时被触发。返回gas
        2. require: 与revert类似，require语句在条件不满足时被触发。返回gas
        3. assert: 语句在遇到内部错误或者不可能发生的情况时被触发。不返回gas 

        使用revert和require来处理外部输入、前置条件和业务逻辑中的错误情况。
        使用assert来处理内部状态的一致性检查以及不应该发生的错误情况。
     */
    function requestTokens() external {
        // 每个地址只能领一次
        require(requestedAddress[msg.sender] == false, "Can't Request Multiple Times!"); 

        //  创建IERC20合约对象
        IERC20 token = IERC20(tokenContract);

        // 看看代币数量够不够分发
        require(token.balanceOf(address(this)) >= amountAllowed, "Faucet Empty!");

        // 发送token
        token.transfer(msg.sender, amountAllowed);

        // 记录领取地址
        requestedAddress[msg.sender] = true;

        // 触发事件
        emit SendToken(msg.sender, amountAllowed);
    }
}