// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;


import {ERC20} from "../../src/ERC20.sol";
import {Test} from "forge-std/Test.sol";


contract ERC20FuzzTest is Test {
    ERC20  token;
    address public user1;
    address public user2;
    address public owner;


    function setUp() public {
        token = new ERC20("goat", "gt");
        owner = address(this);
        user1 = address(1);
        user2 = address(2);
    }



    function testFuzz_Mint(uint256 amount) public {
        token.mint(user1, amount);
        assert(token.balanceOf(user1) == amount);
    }

    function testFuzz_Burn(uint256 amount) public {
        token.mint(user1, amount);
        token.burn(user1, amount);
        assert(token.balanceOf(user1) == 0);
    }

    function testFuzz_Approve(address to, uint256 amount) public {
        vm.prank(owner);
        token.mint(user1, amount);
        vm.prank(user1);
        token.approve(to, amount);
        assert(token.allowances(user1, to) == amount);
    } 

    function testFuzz_TransferFrom(address from, address to, uint256 amount) public {
        vm.prank(owner);
        token.mint(user1, amount);
        vm.prank(user1);
        token.approve(to, amount);
        vm.prank(to);
        token.transferFrom(user1, to, amount);
        assert(token.balanceOf(to) == amount);
    }
}