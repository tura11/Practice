// SPDX-License-Identifier: MIT

pragma solidity 0.8.31;

import {VRFConsumerBaseV2Plus} from "@chainlink/contracts/src/v0.8/vrf/dev/VRFConsumerBaseV2Plus.sol";
import {VRFV2PlusClient} from "@chainlink/contracts/src/v0.8/vrf/dev/libraries/VRFV2PlusClient.sol";
import {AutomationCompatibleInterface} from "@chainlink/contracts/src/v0.8/automation/interfaces/AutomationCompatibleInterface.sol";

contract Lottery {
    error Lottery__InvalidAddress();
    error Lottery__PlayerAlreadyEntered();
    error Lottery__EntryFeeToLow();

    enum LotteryState {
        Open,
        Pending,
        Closed
    }
    // chainlik vrf varaibles
    uint256 private immutable i_subscriptionId;
    bytes32 private immutable i_gasLane;
    uint32 private immutable i_callbackGasLimit;
    uint16 private constant REQUEST_CONFIRMATIONS = 3;
    uint32 private constant NUM_WORDS = 1;

    // lottery variables


    uint256 public constant ENTRY_FEE = 10e18; // 10 tokens
    address[] private players;
    mapping(address => bool) public isEntered;


    constructor(uint256 subscriptionId, bytes32 gasLane, uint32 callbackGasLimit, address vrfCoordinatorV2) VRFConsumerBaseV2Plus(vrfCoordinatorV2) {
        i_subscriptionId = subscriptionId;
        i_gasLane = gasLane;
        i_callbackGasLimit = callbackGasLimit;
        
    }

    function enterLottery(address player, uint256 enterFee) public {
        if (player == address(0)) {
            revert Lottery__InvalidAddress();
        }
        if (enterFee < ENTRY_FEE) {
            revert Lottery__EntryFeeToLow();
        }
        if (isEntered[player]) {
            revert Lottery__PlayerAlreadyEntered();
        }
        players.push(player);
        isEntered[player] = true;
    }

    //todo vrf chanilik implenetanion

    function pickRandomWinner() public {}
}
