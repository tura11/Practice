// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {MyTokenA} from "./MyTokenA.sol";
import {MyTokenB} from "./MyTokenB.sol";

contract Swap {
    error SWAP__INVALID_AMOUNT();

    MyTokenA public tokenA;
    MyTokenB public tokenB;

    uint256 priceAtoB;


    constructor(address _tokenA, address _tokenB, uint256 _priceAtoB) {
        tokenA = _tokenA;
        tokenB = _tokenB;
        priceAtoB = _priceAtoB;
    }


    function swapAforB(uint256 amountA) external {
        if(amountA <= 0) revert SWAP__INVALID_AMOUNT();

        tokenA.transferFrom(msg.sender, address(this), amountA);
        uint256 amountB = amountA * priceAtoB;
        tokenB.transfer(msg.sender, amountB);      
    }

    function swapBforA(uint256 amountB) external {
        if(amountB <= 0) revert SWAP__INVALID_AMOUNT();

        tokenB.transferFrom(msg.sender, address(this), amountB);
        uint256 amountA = amountB / priceAtoB;
        tokenA.transfer(msg.sender, amountA);      
    }
}