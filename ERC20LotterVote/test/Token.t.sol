// SPDX-License-Identifier: MIT

pragma solidity 0.8.31;

import {Token} from "../src/Token.sol";

contract Token {
    
    Token token;


    function setUp() public {
        token = new Token("Token", "TOK", 1000e18);
    }
}