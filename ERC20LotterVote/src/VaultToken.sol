// SPDX-License-Identifier: MIT

pragma solidity 0.8.31;



contract VaultToken {

    string private symbol;
    string private name;
    uint8 private decimals;
    uint256 private initialSupply;
    uint256 totalSupply;

    mapping(address=> uint256) private balances;
    mapping(address=>mapping(address=>bool)) private allowances;

    constructor(string memory _name, string memory _symbol, uint256 _initialSupply){
        name = _name;
        symbol = _symbol;
        decimals = 18;
        initialSupply = _initialSupply;
    }



    
    // function totalSupply() public view returns (uint256)
    // function transfer(address _to, uint256 _value) public returns (bool success)
    // function transferFrom(address _from, address _to, uint256 _value) public returns (bool success)
    // function approve(address _spender, uint256 _value) public returns (bool success)
    // function allowance(address _owner, address _spender) public view returns (uint256 remaining)



    function getName() public view returns (string memory) {
        return name;
    }
    function getSymbol() public view returns (string memory){
        return symbol;
    }
    

    function getDecimals() public view returns (uint8) {
        return decimals;
    }

    function balanceOf(address owner) public view returns(uint256 balance){
        return balances[owner];
    }


}