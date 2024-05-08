// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import "./IERC20.sol";

contract ERC20 is IERC20 {
    
    // 实现接口中的 balanceOf() 方法 这里是将接口中的方法使用状态变量的方法重写 因为solidity默认为pubilc关键字修饰的状态变量设置了getter方法
    // 如果要按照接口中的定义进行设定 则需要对每个方法进行getter的实现 此时只需要把变量状态设置成private即可 调用者通过getter方法来访问状态变量里的值
    // 这里需要注意的是 由于solidity支持函数和状态变量具有相同的名称 所以这里使用状态变量重写了原接口中定义的函数
    mapping(address => uint256) public override balanceOf; // 默认实现getter方法

    // 授权的地址信息 同上一个状态变量
    mapping(address => mapping(address => uint256)) public override allowance; // 默认实现getter方法

    // 发行的代币总量 同上一个状态变量
    uint256 public override totalSupply;  // 默认实现getter方法

    // 发行代币的名称
    string public name;  

    // 一个代号 类似于ETH、USDT
    string public symbol; 

    uint8 public decimals = 18;

    // 构造器 合约部署时候 进行初始化 设定代币的名称以及代号
    constructor(string memory name_, string memory symbol_) {  // 构建的时候要输入代币名称 代币symbol
        name = name_;
        symbol = symbol_;
    }

    // 这里实现transfer接口 代币转账逻辑
    function transfer(address recipient, uint amount) external override returns (bool) {  
        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    // 允许被授权者代表持有者进行一定数量的代币转移操作，而不需要每次转账都要取得持有者的同意。
    function approve(address spender, uint amount) external override returns(bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    // 实现授权转账逻辑 授权可以不转账 这里实现的是授权后转账的逻辑 这里的sender 代币持有者 也不一定就是初始的合约部署 或者 初次分配的地址 
    function transferFrom(address sender,address recipient,uint amount) external override returns (bool) {
        allowance[sender][msg.sender] -= amount;
        balanceOf[sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }

    // 铸造代币的函数 这个不在标准中 这里写成函数的形式 任何人可以铸造代币 但是实际应用中会设置权限只有owner可以铸造 比如可以写进构造函数里
    function mint(uint amount) external {
        balanceOf[msg.sender] += amount;  // 这里有一个点 铸造的代币是放到该函数调用者的账户地址上 合约上不存在代币 
        totalSupply += amount;            // 这里totalSupply 这个变量只是用来记录代币的数量 代币的实际数量由各个账户的余额累加而成，而 totalSupply 只是一个元数据，用来提供关于代币总量的信息。
        /**
          这里触发Transfer函数有几个目的：
          1. 透明性和追溯性： 通过触发 Transfer 事件，可以记录代币的流动，即使是增发操作也可以被记录下来，这有助于提高合约操作的透明度，并允许用户追溯代币的发行情况。
          2. 符合ERC20标准： 触发 Transfer 事件符合 ERC20 标准的要求。根据 ERC20 标准，所有代币转移操作都应该触发 Transfer 事件，无论是实际的代币转移还是其他操作，如增发或销毁。
          3. 通知机制： 触发 Transfer 事件可以通知所有监听该事件的外部应用程序、工具或其他合约，使它们可以及时地响应代币的增发操作，并进行必要的记录或其他操作。
         */
        emit Transfer(address(0), msg.sender, amount); // 代币增发的过程 相当于向函数的调用者进行转账
        // address(0) 表示零地址或空地址 在以太坊网络中 零地址是一个保留地址 不对应任何的有效账户 任何发送到零地址以太币或代币都将永久地丢失
        // 在智能合约中，通常会使用 address(0) 来表示“无地址”或“空地址”，例如在代币合约中，将代表零地址的 address(0) 作为转移操作的来源地址来表示新铸造的代币。
    }

    // 代币销毁
    function burn(uint amount) external {
        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;
        emit Transfer(msg.sender, address(0), amount);
    }
}