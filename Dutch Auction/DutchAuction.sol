// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;


import "../ERC721/ERC721.sol";
import "./Ownable.sol";


contract DutchAuction is ERC721, Ownable {
    //NFT 总数 这里得constant 关键字标明这是一个常量 不可修改
    uint256 public constant COLLECTION_SIZE = 10000;

    // 最高起拍价
    uint256 public constant AUCTION_START_PRICE = 1 ether;

    // 最低价（地板价）
    uint256 public constant AUCTION_END_PRICE = 0.1 ether;

    // 拍卖总时间 这里设置10分钟
    uint256 public constant AUCTION_TIME = 10 minutes;

    // 每过多久 价格衰减
    uint256 public constant AUCTION_DROP_INTERVAL = 1 minutes;

    // 每次价格衰减多少
    uint256 public constant AUCTION_DROP_PER_STEP = 
        (AUCTION_START_PRICE - AUCTION_END_PRICE) / 
        (AUCTION_TIME / AUCTION_DROP_INTERVAL);
    
    // 开始拍卖的时间戳
    uint256 public auctionStartTime;

    // metadata URI
    string private _baseTokenURI;

    // 记录存在的nft id
    uint256[] private _allTokens;

    // 这里还是构造器的继承
    /**
        在智能合约中，通常使用 block.timestamp 来获取当前区块的时间戳。
        这个时间戳表示了当前区块生成的时间，以秒为单位。
        在许多情况下，block.timestamp 是用来记录合约中某些事件发生的时间，比如合约的部署时间、某个操作的时间等等。

        注意：
        1. ，虽然 block.timestamp 在大多数情况下被用来表示时间，但它实际上并不是一个绝对精确的时间。
        它是由区块生成节点设置的，并且可能会存在一定的偏差。
        在一些情况下，如果需要更精确的时间或者避免潜在的攻击，可能需要使用其他的时间机制，比如区块链上的外部时间服务。
     */
    constructor() ERC721("Dutch Auction","Dutch Auction") {
        auctionStartTime = block.timestamp;
    }

    // 获取当前nft的价格
    function getAuctionPrice() public view returns (uint256) {
        if (block.timestamp < auctionStartTime) {
            return AUCTION_START_PRICE;
        } else if (block.timestamp - auctionStartTime >= AUCTION_TIME) {
            return AUCTION_END_PRICE;
        } else {
            uint256 steps = (block.timestamp - auctionStartTime) / AUCTION_DROP_INTERVAL;

            return AUCTION_START_PRICE - (steps * AUCTION_DROP_PER_STEP);
        }
    }


    function auctionMint(uint256 quantity) external payable{
        // 这里转换一下类型 确保类型的一致性 此时_saleStartTime 是拍卖开始时间 
        uint256 _saleStartTime = uint256(auctionStartTime); 

        // 这里确保拍卖以及开始 并且当前时间在拍卖开始之后
        require(_saleStartTime != 0 && block.timestamp >= _saleStartTime,"sale has not started yet");

        // 这里检查拍卖数量是否超过剩余的nft供应
        require(totalSupply() + quantity <= COLLECTOIN_SIZE,"not enough remaining reserved for auction to support desired mint amount");

        // 计算购买总共需要花费多少钱
        uint256 totalCost = getAuctionPrice() * quantity;

        // 这里确保调用者发送的以太币大于等于nft的总成本
        /**
            注意： 这里的msg.value并不是调用者账户上的以太币数量
            而是执行一个以太币交易中所发送的以太币数量
         */
        require(msg.value >= totalCost, "Need to send more ETH.");

        // 循环铸造 因为_mint函数每次智能铸造一个 同时总供应totalSupply 每次也加一 
        // 这样铸造出来的nft 的tokenid也不一样 最后再把每个nft 给到购买者账户
        for(uint256 i = 0; i < quantity; i++) {
            uint256 mintIndex = totalSupply();
            _mint(msg.sender, mintIndex);
            _addTokenToAllTokensEnumeration(mintIndex);
        }

        // 多余ETH退款
        if (msg.value > totalCost) {
            // 注意 这里的 payable() 是一个类型转化器 将一个地址转化为可支付的地址 相当于地址调用transfer函数来进行转账
            payable(msg.sender).transfer(msg.value - totalCost); //注意一下这里是否有重入的风险
        }
    }

    // 提款函数，onlyOwner
    function withdrawMoney() external onlyOwner {
        // 这里实现了将合约里的以太转到了msg.sender里 也就是owner手了
        /**
            这里是使用了call函数来实现了交易发送ETH call在soldity中 address类型的低级成员函数 用来发送ETH以及和其他合约交互
            这里的语法是 目标合约地址.call{value:发送数额, gas:gas数额}(二进制编码); 表示只进行了转账 没有传递任何调用数据
            这个函数的返回值为(bool, data) 对应call是否成功以及目标函数的返回值
         */
        (bool success, ) = msg.sender.call{value: address(this).balance}(""); 
        require(success, "Transfer failed.");
    }
    
}