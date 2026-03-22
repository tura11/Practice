// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import {ERC20} from "../../src/ERC20.sol";
import {Test} from "forge-std/Test.sol";

contract HandlerERC20 is Test {
    ERC20 token;

    address[] public actors;

    uint256 public ghostTotalMinted;
    uint256 public ghostTotalBurned;

    constructor(ERC20 _token) {
        token = _token;

        actors.push(makeAddr("Alice"));
        actors.push(makeAddr("Bob"));
        actors.push(makeAddr("Charlie"));
    }

    function mint(uint256 actorSeed, uint256 amount) public {
        address to = _getActor(actorSeed);
        amount = bound(amount,1, 1000e18);
        token.mint(to, amount);
        ghostTotalMinted += amount;
    }

    function burn(uint256 actorSeed, uint256 amount) public {
        address from = _getActor(actorSeed);

        uint256 balance = token.balanceOf(from);
        if(balance == 0) {
            return;
        }

        amount = bound(amount,1, balance);
        token.burn(from, amount);
        ghostTotalBurned += amount;
    }


    function transfer(uint256 fromSeed, uint256 toSeed, uint256 amount) public {
        address from = _getActor(fromSeed);
        address to = _getActor(toSeed);
        uint256 balance = token.balanceOf(from);
        if(balance == 0) return;

        amount = bound(amount, 1, balance);
        vm.prank(from);
        token.transfer(to, amount);
    }

    function approve(uint256 ownerSeed,uint256 spenderSeed, uint256 amount) public {
        address owner = _getActor(ownerSeed);
        address spender = _getActor(spenderSeed);
        amount = bound(amount,1, type(uint256).max);
        vm.prank(owner);
        token.approve(spender, amount);
    }


    function transferFrom(uint256 fromSeed, uint256 toSeed, uint256 amount) public {
        address from = _getActor(fromSeed);
        address to = _getActor(toSeed);
        uint256 balance = token.balanceOf(from);
        if(balance == 0) return;
        uint256 allowance = token.allowances(from, to);
        if(allowance == 0) {
            amount = bound(amount, 1, balance);
            vm.prank(from);
            token.approve(to, amount);
        }else {
            amount = bound(amount, 1, _min(balance, allowance));
        }
       
        vm.prank(to);
        token.transferFrom(from, to, amount);

    }


     function _getActor(uint256 seed) internal view returns (address) {
        return actors[seed % actors.length];
    }

    function _min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }

    function getActors() public view returns (address[] memory) {
        return actors;
    }

    function totalMinted() public view returns (uint256) {
        return ghostTotalMinted;
    }

    function totalBurned() public view returns (uint256) {
        return ghostTotalBurned;
    }
}


