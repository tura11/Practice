// SPDX-License-Identifier: MIT

pragma solidity 0.8.31;

import {Token} from "../src/Token.sol";

contract Token {
    
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


    //todo 100% coverage
}