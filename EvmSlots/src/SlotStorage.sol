// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;


contract SlotStorage {
    
    uint256 public a;
    uint256 public b;
    bytes32 public c;


    function setValues(uint256 _a, uint256 _b, bytes32 _c) public {
        a = _a;
        b = _b;
        c = _c;
    }
}