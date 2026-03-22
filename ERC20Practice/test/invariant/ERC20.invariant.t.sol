// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;


import {Test} from "forge-std/Test.sol";
import {ERC20} from "../../src/ERC20.sol";
import {HandlerERC20} from "../invariant/HandlerERC20.sol";


contract ERC20InvariantTest is Test {   
    ERC20 token;
    HandlerERC20 handler;




    function setUp() public {
        token = new ERC20("token", "TOK");
        handler = new HandlerERC20(token);

        targetContract(address(handler));
    }


    function  invariant_TotalSupplyEqualsAllBalances() public {
        address[] memory actors = handler.getActors();

        uint256 sumOfBalances = 0;

        for(uint256 i = 0; i < actors.length; i++) {
            sumOfBalances += token.balanceOf(actors[i]);
        }

        assertEq(token.totalSupply(), sumOfBalances);

    }

    function invariant_TotalSupplyEqualsTotalMintedMinusTotalBurned() public {
        assertEq(token.totalSupply(), handler.totalMinted() - handler.totalBurned());
    }
}