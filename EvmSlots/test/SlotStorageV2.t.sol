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


    function testStoreB() public {
        bytes32 slot0 = vm.load(address(slot), bytes32(0));
        uint256 s = uint256(slot0);
        console.log("b value: ", slot.b());

        uint256 mask = (uint256(type(uint64).max) << 128);
        s = s & ~mask;
        s = s | (uint256(uint64(5)) << 128); // we are set the vaule from 2 to 5;
        vm.store(address(slot), bytes32(0), bytes32(s));
        console.log("b value: ", slot.b());
    
    }


    function testStoreC() public {
        bytes32 slot0 = vm.load(address(slot), bytes32(0));
        uint256 s = uint256(slot0);
        console.log("c value: ", slot.c());


        uint256 mask = (uint256(type(uint32).max) << 192);
        s = s & ~mask;
        s = s | (uint256(uint32(10)) << 192); // we are set the vaule from 3 to 10;
        vm.store(address(slot), bytes32(0), bytes32(s));
        console.log("c value: ", slot.c());
    
    }

    function testStoreD() public {
        bytes32 slot0 = vm.load(address(slot), bytes32(0));
        uint256 s = uint256(slot0);
        console.log("d value: ", slot.d());


        uint256 mask = (uint256(type(uint32).max) << 224);
        s = s & ~mask;
        s = s | (uint256(uint32(15)) << 224); // we are set the vaule from 4 to 15;
        vm.store(address(slot), bytes32(0), bytes32(s));
        console.log("d value: ", slot.d());
    
    }


}