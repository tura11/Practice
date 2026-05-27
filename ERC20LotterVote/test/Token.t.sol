// SPDX-License-Identifier: MIT

pragma solidity 0.8.31;

import {Token} from "../src/Token.sol";
import {Test} from "forge-std/Test.sol";

contract TestToken is Test {
    Token token;
    address owner;

    function setUp() public {
        token = new Token("Token", "TOK", 1000e18);
        owner = address(this);
    }

    function testMint() public {
        vm.prank(owner);
        token.mint(1000e18);
        assert(token.balanceOf(owner) == 1000e18);
    }

    function testBurn() public {
        vm.prank(owner);
        token.mint(1000e18);
        token.burn(500e18);
        assert(token.balanceOf(owner) == 500);
    }

    function testTransfer() public {
        vm.prank(owner);
        token.mint(1000e18);
        token.transfer(address(1), 500e18);
        assert(token.balanceOf(address(1)) == 500e18);
    }

    //todo 100% coverage
}
