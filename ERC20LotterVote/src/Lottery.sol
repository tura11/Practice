// SPDX-License-Identifier: MIT


pragma solidity 0.8.31;

import "https://github.com/smartcontractkit/chainlink/blob/develop/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "https://github.com/smartcontractkit/chainlink/blob/develop/contracts/src/v0.8/VRFConsumerBaseV2.sol";
import "@chainlink/contracts/src/v0.8/ConfirmedOwner.sol";

import {Vault} from "./Vault.sol";

contract Lottery {
    error Lottery__InvalidAddress();
    error Lottery__PlayerAlreadyEntered();
    error Lottery__EntryFeeToLow();

    struct requestStatus {
        bool fullfilled;
        bool exist;
        uint256[] randomWords;
    }
    VRFCoordinatorV2Interface COORDINATOR;
    uint64 s_subscriptionId;
    uint256[] public requestsIds;
    uint256 public lastRequestId;
    bytes32 immutable keyHash;
    address public immutable linkToken;

    uint256 public constant ENTRY_FEE = 10e18; // 10 tokens
    address[] private players;
    mapping(address => bool) public isEntered;
    mapping(uint256 => RequestStatus) public s_requests;

    function enterLottery(address player, uint256 enterFee) public {
        if(player == address(0)){
            revert Lottery__InvalidAddress();
        }
        if(enterFee < ENTRY_FEE){
            revert Lottery__EntryFeeToLow();
        }
        if(isEntered[player]){
            revert Lottery__PlayerAlreadyEntered();
        }
        players.push(player);
        isEntered[player] = true;
    }

    //todo vrf chanilik implenetanion


    function pickRandomWinner(){
        
    }


}