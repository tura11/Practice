// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;


import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {UUPSUpgradeable}from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";


contract CounterV1 is Initializable, UUPSUpgradeable, OwnableUpgradeable {
    // ================================================================
    // Storage
    // ================================================================

    uint256 public count;

    // ================================================================
    // Initialization
    // ================================================================


    constructor(){
        _disableInitializers(); 
    }


    function initialize(address _owner) external initializer {
        __Ownable_init(_owner);
        __UUPSUpgradeable_init();
    }


    // ================================================================
    // External Functions
    // ================================================================

    function increment() external {
        count += 1;
    }


    // ================================================================
    // Internal Functions
    // ================================================================


    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}


}