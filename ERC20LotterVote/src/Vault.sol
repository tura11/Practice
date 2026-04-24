// SPDX-License-Identifier: MIT

pragma solidity 0.8.31;


contract Vault {

    error Vault__CannotDepositZero();
    error Vault__NoEnoughMoneyToWithdraw();
    error Vault__CannotWithdrawZero();

    address immutable owner;
    uint256 totalSupply;

    mapping(address => uint256) private balances;


    event Deposited(address depositor, uint256 amount);
    event Withdrawed(address withdrawer, uint256 amount);

    constructor(address _owner) {
        owner = _owner;
    }



    function deposit(uint256 amount) external {
        if(amount == 0){
            revert Vault__CannotDepositZero();
        }

        balances[msg.sender] += amount;
        totalSupply += amount;

        emit Deposited(msg.sender, amount);
    }


    function withdraw(uint256 amount) external {
        if(amount == 0){
            revert Vault__CannotWithdrawZero();
        }

        if(balances[msg.sender] < amount) {
            revert Vault__NoEnoughMoneyToWithdraw();
        }

        balances[msg.sender] -= amount;
        totalSupply -= amount;

        emit Withdrawed(msg.sender, amount);
    }
} 