// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {IERC20} from "./interfaces/IERC20.sol";

contract Pair {

    event Sync(uint112 reserve0, uint112 reserve1);
    event TransferLP(address indexed from, address indexed to, uint256 amount);
    event Mint(address indexed sender, uint256 amount0, uint256 amount1);
    event Burn(address indexed sender, address indexed to, uint256 amount0, uint256 amount1);
    
    IERC20 public token0;
    IERC20 public token1;

    uint112 private reserve0;
    uint112 private reserve1;
    uint32 private blockTimestampLast;

    string public name = "SimpleLP";
    string public symbol = "sLP";
    uint8 public decimals = 18;
    uint256 public totalSupplyLP;

    mapping(address => uint256) public balanceOf;
    
    constructor(address _token0, address _token1) {
        token0 = IERC20(_token0);
        token1 = IERC20(_token1);
    }


    function _update(uint256 balance0, uint256 balance1) private {
        require(balance0 <= type(uint112).max && balance1 <= type(uint112).max, "Overflow");
        reserve0 = uint112(balance0);
        reserve1 = uint112(balance1);
        blockTimestampLast = uint32(block.timestamp % 2**32);
        emit Sync(reserve0, reserve1);
    }


    function _mintLP(address to, uint256 amount) internal {
        totalSupplyLP += amount;
        balanceOf[to] += amount;
        emit TransferLP(address(0), to, amount);
    }

    function _burnLP(address from, address to, uint256 amount) internal {
        require(balanceOf[from] >= amount, "Lp balance to low");
         totalSupplyLP -= amount;
         balanceOf[from] -= amount;
         emit TransferLP(from, to, amount);
    }

    function addLiqudity(uint256 amount0, uint256 amount1) external returns (uint256 liquidity) {
        require(amount>0 && amount1 >0, "Amount cant be zero");
        require(token0.transferFrom(msg.sender, address(this), amount0), "Transfer failed");
        require(token1.transferFrom(msg.sender, address(this), amount1), "Transfer failed");
        
        uint256 balance0 = token0.balanceOf(address(this));
        uint256 balance1 = token1.balanceOf(address(this));
       

       if(totalSupplyLP == 0) {
        liquidity = _sqrt(amount0 * amount1);
        require(liquidity >0, "Insufficient liqudity");
       _mintLP(msg.sender, liquidity); 
       }else{
        uint256 liquidity0 = amount0 * reserve1 / reserve0;
        uint256 liquidity1 = amount1 * reserve0 / reserve1;
        liquidity = liquidity0 < liquidity1 ? liquidity0 : liquidity1;
        require(liquidity > 0, "Insufficient liquidity minted");
        _mintLP(msg.sender, liquidity);
       }

       _update(balance0, balance1);
        emit Mint(msg.sender, amount0, amount1);
    }

    function removeLiquidity(uint256 lpAmount, address to) external returns (uint256 amount0, uint256 amount1) {
        require(lpAmount > 0, "Zero LPamount");
        require(balanceOf[msg.sender] >= lpAmount, "LP balance low");

        uint256 balance0 = token0.balanceOf(address(this));
        uint256 balance1 = token1.balanceOf(address(this));

        amount0 = lpAmount * reserve0 / totalSupplyLP;
        amount1 = lpAmount * reserve1 / totalSupplyLP;


        _burnLP(msg.sender, address(0), lpAmount);
        

        require(token0.transfer(to, amount0), "transfer0 fail");
        require(token1.transfer(to, amount1), "transfer1 fail");

        balance0 = token0.balanceOf(address(this));
        balance1 = token1.balanceOf(address(this));
        _update(balance0, balance1);

        emit Burn(msg.sender, to, amount0, amount1);
    }
        
    function swap(
    uint256 amount0In,
    uint256 amount1In,
    address to
    ) external returns (uint256 amount0Out, uint256 amount1Out) {
        require(amount0In > 0 || amount1In > 0, "Insufficient input amount");
        require(to != address(0), "Invalid recipient");

        uint256 balance0 = token0.balanceOf(address(this));
        uint256 balance1 = token1.balanceOf(address(this));

       
        if(amount0In > 0) {
            uint256 amount0InWithFee = amount0In * 997 / 1000;
            amount1Out = reserve1 - (reserve0 * reserve1 / (reserve0 + amount0InWithFee));
            require(amount1Out > 0, "Insufficient output amount");
            require(token1.transfer(to, amount1Out), "Transfer1 failed");
        } else {
            uint256 amount1InWithFee = amount1In * 997 / 1000;
            amount0Out = reserve0 - (reserve0 * reserve1 / (reserve1 + amount1InWithFee));
            require(amount0Out > 0, "Insufficient output amount");
            require(token0.transfer(to, amount0Out), "Transfer0 failed");
        }

        balance0 = token0.balanceOf(address(this));
        balance1 = token1.balanceOf(address(this));
        _update(balance0, balance1);
    }




}