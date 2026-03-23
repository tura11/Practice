// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {SlotStorage} from "../src/SlotStorage.sol";

contract CounterTest is Test {
    SlotStorage slot;

    function setUp() public {
        slot = new SlotStorage();
        slot.setValues(1, 2, bytes32(uint256(0xacacac)));
    }

    function testSetValues() public { // change values of variables
        console.log("a value: ", slot.a());
        console.log("b value: ", slot.b());
        vm.store(address(slot), bytes32(uint256(0)), bytes32(uint256(3)));
        assertEq(slot.a(), 3);
        vm.store(address(slot), bytes32(uint256(1)), bytes32(uint256(4)));
        assertEq(slot.b(), 4);
        vm.store(address(slot), bytes32(uint256(2)), bytes32(uint256(0xababab)));
        assertEq(slot.c(), bytes32(uint256(0xababab)));
        console.log("a value: ", slot.a());
        console.log("b value: ", slot.b());
    }


    function testSlotVariables() public { // read values of variables
        bytes32 value1 = vm.load(address(slot), bytes32(uint256(0)));
      
        bytes32 value2 = vm.load(address(slot), bytes32(uint256(1)));
    
        bytes32 value3 = vm.load(address(slot), bytes32(uint256(2)));

        console.log("value1: ", uint256(value1));
        console.log("value2: ", uint256(value2));
        console.log("value3: ", uint256(value3));
    }


}
