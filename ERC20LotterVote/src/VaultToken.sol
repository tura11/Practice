// SPDX-License-Identifier: MIT

pragma solidity 0.8.31;

contract VaultToken {

    error VaultToken__AddressZero(address adderess);
    error VaultToken__CannotAllowanceToYourself();
    error VaultToken__InvalidAllowance();

    string private symbol;
    string private name;
    uint8 private decimals;
    uint256 private initialSupply;
    uint256 totalSupply;

    mapping(address => uint256) private balances;
    mapping(address => mapping(address => uint256)) private allowances;

    event Minted(address indexed owner, uint256 amount);
    event Burned(address indexed owner, uint256 amount);

    constructor(string memory _name, string memory _symbol, uint256 _initialSupply) {
        name = _name;
        symbol = _symbol;
        decimals = 18;
        initialSupply = _initialSupply;
    }
    function mint(uint256 amount) external {
        balances[msg.sender] += amount;
        totalSupply += amount;
        emit Minted(msg.sender, amount);
    }


    function burn(uint256 amount) external {
        balances[msg.sender] -= amount;
        totalSupply -= amount;
        emit Burned(msg.sender, amount);
    }

    function allowance(address owner, address spender) public  returns(uint256) {
        if (owner == address(0)){
            revert VaultToken__AddressZero(owner);
        }

        if (spender == address(0)){
            revert VaultToken__AddressZero(spender);
        }

        if (spender == msg.sender){
            revert VaultToken__CannotAllowanceToYourself();
        }

        return allowances[owner][spender];
    }


    function approve(address spender, uint256 value) public returns(bool){
        if(spender == address(0)){
            revert VaultToken__AddressZero(spender);
        }
        allowances[msg.sender][spender] = value;
        return true;
    }


    function transfer(address to, uint256 amount) public  returns(bool){
        balances[msg.sender] -= amount;
        balances[to] += amount;

        return true;
    }

    function transferFrom(address from, address to, uint256 amount) public  returns(bool){
        balances[from] -= amount;
        balances[to] += amount;
        allowances[from][to] -= amount;
        
        return true;

    }

    function getName() public view returns (string memory) {
        return name;
    }

    function getSymbol() public view returns (string memory) {
        return symbol;
    }

    function getDecimals() public view returns (uint8) {
        return decimals;
    }

    function balanceOf(address owner) public view returns (uint256 balance) {
        return balances[owner];
    }

    function getTotalSupply() public view returns (uint256) {
        return totalSupply;
    }
}

