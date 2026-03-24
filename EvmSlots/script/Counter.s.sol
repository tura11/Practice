// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {SlotStorage} from "../src/SlotStorage.sol";

contract CounterScript is Script {
    SlotStorage slot;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        slot = new SlotStorage();

        vm.stopBroadcast();

        console.log("Contract address", address(slot));
    }
}
