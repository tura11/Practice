// SPDX-License-Identifier: MIT
pragma solidity 0.8.31;

contract VaultToken {
    error VaultToken__AddressZero(address addr);
    error VaultToken__InsufficientBalance();
    error VaultToken__InsufficientAllowance();

    string private symbol;
    string private name;
    uint8 private decimals;
    uint256 public totalSupply;

    mapping(address => uint256) private balances;
    mapping(address => mapping(address => uint256)) private allowances;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Minted(address indexed owner, uint256 amount);
    event Burned(address indexed owner, uint256 amount);

    constructor(string memory _name, string memory _symbol, uint256 _initialSupply) {
        name = _name;
        symbol = _symbol;
        decimals = 18;
        totalSupply = _initialSupply;
        balances[msg.sender] = _initialSupply;
    }

    function mint(uint256 amount) external {
        balances[msg.sender] += amount;
        totalSupply += amount;
        emit Minted(msg.sender, amount);
    }

    function burn(uint256 amount) external {
        if (balances[msg.sender] < amount) revert VaultToken__InsufficientBalance();
        balances[msg.sender] -= amount;
        totalSupply -= amount;
        emit Burned(msg.sender, amount);
    }

    function approve(address spender, uint256 value) public returns (bool) {
        if (spender == address(0)) revert VaultToken__AddressZero(spender);
        allowances[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function allowance(address owner, address spender) public view returns (uint256) {
        return allowances[owner][spender];
    }

    function transfer(address to, uint256 amount) public returns (bool) {
        if (to == address(0)) revert VaultToken__AddressZero(to);
        if (balances[msg.sender] < amount) revert VaultToken__InsufficientBalance();
        balances[msg.sender] -= amount;
        balances[to] += amount;
        emit Transfer(msg.sender, to, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) public returns (bool) {
        if (to == address(0)) revert VaultToken__AddressZero(to);
        if (balances[from] < amount) revert VaultToken__InsufficientBalance();
        if (allowances[from][msg.sender] < amount) revert VaultToken__InsufficientAllowance();
        allowances[from][msg.sender] -= amount;
        balances[from] -= amount;
        balances[to] += amount;
        emit Transfer(from, to, amount);
        return true;
    }

    function balanceOf(address owner) public view returns (uint256) { return balances[owner]; }
    function getName() public view returns (string memory) { return name; }
    function getSymbol() public view returns (string memory) { return symbol; }
    function getDecimals() public view returns (uint8) { return decimals; }
}