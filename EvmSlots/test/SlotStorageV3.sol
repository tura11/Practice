// SPDX-License-Identifier: MIT


pragma solidity ^0.8.20;



import {Test, console} from "forge-std/Test.sol";
import {SlotStorageV3} from "../src/SlotStorageV3.sol";



contract SlotStorageV3Test is Test {
    SlotStorageV3 slot;


    function setUp() public {
        slot = new SlotStorageV3();
    }



    function testLoadMutli() public {

        bytes32 slot1 = vm.load(address(slot), bytes32(uint256(1)));
        bytes32 slot2 = vm.load(address(slot), bytes32(uint256(2)));

        uint256 c = uint256(slot1);
        uint256 d = uint256(slot2);
        console.log("c value: ", c);
        console.log("d value: ", d);
    }


    function testLoadSingle() public {
        bytes32 slot0 = vm.load(address(slot), bytes32(uint256(0)));

        uint256 s = uint256(slot0);

        uint128 a = uint128(s);
        uint128 b = uint128(s >> 128);
        console.log("a value: ", a);
        console.log("b value: ", b);

    }
}