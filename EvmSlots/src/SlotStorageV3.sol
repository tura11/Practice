// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;


contract SlotStorageV3 {
    
    struct SingleSlot {
        uint128 a;
        uint128 b;
    }


    struct MultipleSlot {
        uint256 c;
        uint256 d;
    }


    SingleSlot public single = SingleSlot({a: 1, b: 2});
    MultipleSlot public multi = MultipleSlot({c: 3, d: 4});


}