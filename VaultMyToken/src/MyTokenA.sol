// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract MyToken {

    error MyToken__InvalidAddress();


    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowances;

    event Transfer(address from, address to, uint256 value);
    event Approval(address owner, address spender, uint256 value);


    constructor(string memory _name, string memory _symbol) {
        name = _name;
        symbol = _symbol;
        decimals = 18;
    }

    function mint(address to, uint256 amount) public {
        if(to == address(0)) {
            revert MyToken__InvalidAddress();
        }
        totalSupply += amount;
        balanceOf[to] += amount;
        emit Transfer(address(0), to, amount);
    }


    function transfer(address to, uint256 amount) public returns (bool) {
        _transfer(msg.sender, to, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) public returns (bool) {
        uint256 currnetAllowance = allowances[from][msg.sender];
        require(currnetAllowance >= amount, "ERC20: transfer amount exceeds allowance");
        
        allowances[from][msg.sender] = currnetAllowance - amount;

        _transfer(from, to, amount);
        return true;
    }


    function approve(address spender, uint256 amount) public returns (bool) {
        allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function _transfer(address from, address to, uint256 amount) internal {
        require(to != address(0), "ERC20: transfer to zero");
        uint256 fromBalance = balanceOf[from];
        require(fromBalance >= amount, "ERC20: balance too low");

        balanceOf[from] = fromBalance - amount;
        balanceOf[to] += amount;

        emit Transfer(from, to, amount);
    }

    function balanceOf(address user) public view returns (uint256) {
        return balanceOf[user];
    }






}