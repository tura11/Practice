// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;


import {ERC20} from "../../src/ERC20.sol";
import {Test} from "forge-std/Test.sol";


contract ERC20Test is Test {
    ERC20 public token;
    address public user1;
    address public user2;


    function setUp() public {
        token = new ERC20("goat", "gt");
        user1 = address(1);
        user2 = address(2);


    }


    function testMint() public {
        token.mint(user1, 100);
        assert(token.balanceOf(user1) == 100);
    }

    function testBurn() public {
        token.mint(user1, 100);
        token.burn(user1, 50);
        assert(token.balanceOf(user1) == 50);
    }


    function testTransfer() public {
        token.mint(user1, 100);
        vm.prank(user1);
        token.transfer(user2, 50);
        assert(token.balanceOf(user1) == 50);
        assert(token.balanceOf(user2) == 50);
    }

    function testTransferFrom() public {
        token.mint(user1, 100);
        vm.prank(user1);
        token.approve(user2, 50);
        vm.prank(user2);
        token.transferFrom(user1, user2, 50);
        assert(token.balanceOf(user1) == 50);
        assert(token.balanceOf(user2) == 50);
    }
}