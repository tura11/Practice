// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;


import {NFT} from "../../src/ERC721.sol";
import {Test} from "forge-std/Test.sol";


contract NftFuzzTest is Test {


    NFT nft;
    address owner;
    address user1;
    address user2;

    function setUp() public {
        nft = new NFT("goat", "gt", "ipfs://QmeSjSinHpPnmXmspMjwiXyN6zS4E9zccariGR3jxcaWtq/");
        owner = address(this);
        user1 = address(1);
        user2 = address(2);
    }


    function testFuzz_Mint(address to) public {
        vm.assume(to != address(0));
        vm.prank(owner);
        nft.mint(to);
        assertEq(nft.balanceOf(to), 1);
        assertEq(nft.ownerOf(1), to);
    }

    function testFuzz_SetApproveForAll(address operator, bool approved) public {
        vm.assume(operator != user1);
        vm.prank(user1);
        bool approved = true;
        nft.setApprovalForAll(operator, approved);
        assertEq(nft.isApprovedForAll(user1,operator), true);
    }


}


