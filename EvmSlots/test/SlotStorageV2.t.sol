// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;


import {Test, console} from "forge-std/Test.sol";
import {SlotStorageV2} from "../src/SlotStorageV2.sol";


contract SlotStorageTestV2 is Test {
    SlotStorageV2 slot;


    function setUp() public {
        slot = new SlotStorageV2();
    }


    function testLoadB() public {

        bytes32 slot0 = vm.load(address(slot), bytes32(0));

        uint64 b = uint64(uint256(slot0) >> 128); // shift 128 bits, now b is on 0 bit
        console.log("b value: ", b);

    }

    function testLoadC() public {
        bytes32 slot0 = vm.load(address(slot), bytes32(0));

        uint32 c = uint32(uint256(slot0) >> 192); // shift 192 bits, now c is on 0 bit
        console.log("c value: ", c);
    }


    function testLoadD() public {
        bytes32 slot0 = vm.load(address(slot), bytes32(0));

        uint32 d = uint32(uint256(slot0) >> 224); // shift 256 bits, now d is on 0 bit
        console.log("d value: ", d);
    }


}