// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract ERC20 {

    event Transfer(address indexed from,address indexed to, uint256 value);
    
    string public s_name;
    string public s_symbol;
    uint256 public s_totalSupply;
    uint256 public immutable i_decimals;
    

    mapping(address => uint256) public balances;
    mapping(address => mapping(address => uint256)) public allowances;

    constructor(string memory _name, string memory _symbol) {
        s_name = _name;
        s_symbol = _symbol;
        i_decimals = 18;
    }

    function transfer(address recipient, uint256 amount ) external returns(bool){
        require(amount > 0, "Insufficient amount");
        require(address(recipient) != address(0), "Invalid address");
        balances[recipient] += amount;
        balances[msg.sender] -= amount;
        emit Transfer(msg.sender,recipient, amount);
        return true;
    }

    function approve(address to, uint256 amount) external returns(bool) {
        allowances[msg.sender][to] = amount;
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) external returns(bool){
        balances[from] -= amount;
        balances[to] += amount;
        allowances[from][msg.sender] -= amount;
        emit Transfer(from, to, amount);
        return true;
    }

    function _mint(address to, uint256 amount) internal {
        balances[to] += amount;
        s_totalSupply += amount;
        emit Transfer(address(0), to , amount);
    } 

    function _burn(address from, uint256 amount) internal {
        balances[from] -= amount;
        s_totalSupply -= amount;
    }


    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }

    function burn(address from, uint256 amount) external {
        _burn(from, amount);
    }

    function balanceOf(address account) external view returns(uint256) {
        return balances[account];
    }

    function totalSupply() external view returns(uint256) {
        return s_totalSupply;
    }




    


}
