// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {NFT} from "../../src/ERC721.sol";

contract ERC721 is Test {
    NFT nft;
    address owner;
    address user1;
    string baseURI = "ipfs://QmeSjSinHpPnmXmspMjwiXyN6zS4E9zccariGR3jxcaWtq/";



    function setUp() public {
        nft = new NFT("goat", "gt", baseURI);
        owner = address(this);
        user1 = address(1);
    }


    function testMint() public {
        vm.prank(owner);
        uint tokenId = nft.mint(user1);
        assert(nft.balanceOf(user1) == 1);
        assert(nft.ownerOf(tokenId) == user1);
    }

    function testMintRevertIfNotOwner() public {
        vm.prank(user1);
        vm.expectRevert(NFT.NotOwner.selector);
        uint256 tokenId = nft.mint(user1);
        
    }

    function testBurn() public {
        vm.prank(owner);
        uint tokenId = nft.mint(user1);
        vm.prank(user1);
        nft.burn(tokenId);
        assert(nft.balanceOf(user1) == 0);
    }

    function testApproval() public {
        vm.prank(owner);
        uint tokenId = nft.mint(owner);
        nft.approve(user1, tokenId);
        assert(nft.getApproved(tokenId) == user1);
    }

    function testTransferFrom() public {
        vm.prank(owner);
        uint tokenId = nft.mint(user1);
        uint tokenId2 = nft.mint(owner);
        nft.transferFrom(owner, user1, tokenId2);
        assert(nft.ownerOf(tokenId2) == user1);
    }

    function testSetApprovalForAll() public {
        vm.prank(owner);
        nft.setApprovalForAll(user1, true);
        assert(nft.isApprovedForAll(owner, user1));
    }


    function testTokenURI() public {
    uint tokenId = nft.mint(user1);
    string memory uri = nft.tokenURI(tokenId);
    
    assertEq(
        uri, 
        "ipfs://QmeSjSinHpPnmXmspMjwiXyN6zS4E9zccariGR3jxcaWtq/1"
    );
    }

    function testTokenURIRevertsForNonexistent() public {
        vm.expectRevert(NFT.TokenDoesNotExist.selector);
        nft.tokenURI(999);
    }


}


