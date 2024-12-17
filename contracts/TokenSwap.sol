// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract TokenSwap {
    struct SwapOrder {
        address creator;
        address tokenA;
        address tokenB;
        uint256 amountA;
        uint256 amountB;
        bool isCompleted;
    }

    mapping(uint256 => SwapOrder) public swapOrders;
    uint256 public orderCount;

    event OrderCreated(
        uint256 indexed orderId,
        address indexed creator,
        address tokenA,
        address tokenB,
        uint256 amountA,
        uint256 amountB
    );
    event OrderCompleted(uint256 indexed orderId, address indexed taker);

    function createOrder(
        address _tokenA,
        address _tokenB,
        uint256 _amountA,
        uint256 _amountB
    ) external returns (uint256) {
        require(_tokenA != address(0) && _tokenB != address(0), "Invalid token addresses");
        require(_amountA > 0 && _amountB > 0, "Invalid amounts");

        IERC20(_tokenA).transferFrom(msg.sender, address(this), _amountA);

        uint256 orderId = orderCount++;
        swapOrders[orderId] = SwapOrder({
            creator: msg.sender,
            tokenA: _tokenA,
            tokenB: _tokenB,
            amountA: _amountA,
            amountB: _amountB,
            isCompleted: false
        });

        emit OrderCreated(orderId, msg.sender, _tokenA, _tokenB, _amountA, _amountB);
        return orderId;
    }

    function fulfillOrder(uint256 _orderId) external {
        SwapOrder storage order = swapOrders[_orderId];
        require(!order.isCompleted, "Order already completed");
        require(order.creator != msg.sender, "Cannot fulfill own order");

        IERC20(order.tokenB).transferFrom(msg.sender, order.creator, order.amountB);
        IERC20(order.tokenA).transfer(msg.sender, order.amountA);

        order.isCompleted = true;
        emit OrderCompleted(_orderId, msg.sender);
    }
}