// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {MyToken} from "../src/MyToken.sol";

contract MyTokenTest is Test {
    MyToken public token;
    uint256 public constant INITIAL_SUPPLY = 100; // 100usdc
    address public user1;
    address public user2;


    function setUp() public {
        token = new MyToken("MyToken", "MTK");
        user1 = makeAddr("user1");
        user2 = makeAddr("user2");
        token.mint(user1,INITIAL_SUPPLY);
    } 

    function testConstructor() public {
        assertEq(token.name(), "MyToken");
        assertEq(token.symbol(), "MTK");
        assertEq(token.decimals(), 18);
        assertEq(token.totalSupply(), 100);
    }

    function testMintSuccess() public {
        vm.startPrank(user1);
        token.mint(user1, 100);
        vm.stopPrank();
        assertEq(token.totalSupply(), 200);
        assertEq(token.getUserBalance(user1), 200);
    }

    function testMintReverts() public {
        vm.startPrank(user1);
        address recipient = address(0);
        token.approve(recipient, 100);
        vm.expectRevert(MyToken.MyToken__InvalidAddress.selector);
        token.mint(recipient, 100);
        vm.stopPrank();
    }
    function testTransferSucces() public {
        vm.startPrank(user1);
        token.mint(user1, 1000);
        token.transfer(user2, 500);
        assertEq(token.getUserBalance(user2), 500);
    }

    function testTransferFromSucces() public {
        vm.startPrank(user1);
        token.mint(user1, 1000);
        token.approve(user1, 1000);
        token.transferFrom(user1, user2, 500);
        token.transferFrom(user1, user2, 300);
        assertEq(token.getUserBalance(user2), 800);
    }


}