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

    event Minted(owner, amount);
    event Burned(owner, amount);

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
        totalSupply -= asmount;
        emit Burned(msg.sender, amount);
    }

    function allowance(address owner, address spender) public view returns(uint256) {
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


    function approve(address spender, uint256 value) public view returns(bool){
        if(spender == address(0)){
            revert VaultToken__AddressZero(spender);
        }
        allowances[msg.sender][spender] = value;
        return true;
    }


    function transfer(address to, uint256 amount) public view returns(bool){
        balances[msg.sender] -= amount;
        balances[to] += amount;

        (bool success,) = payable(to).call{value: amount}("");
        return success;
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
    // function transfer(address _to, uint256 _value) public returns (bool success)
    // function transferFrom(address _from, address _to, uint256 _value) public returns (bool success)
