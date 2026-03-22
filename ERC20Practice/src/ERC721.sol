// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

contract NFT  {

    // ========== ERRORS ==========
    error InvalidAddress();
    error TokenDoesNotExist();
    error NotAuthorized();
    error CannotApproveToCurrentOwner();
    error CannotApproveSelf();
    error FromIsNotOwner();
    error CannotTransferToZeroAddress();
    error CannotMintToZeroAddress();
    error NotOwner();
    error OnlyOwner();

    // ========== EVENTS ==========
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    // ========== STATE VARIABLES ==========
    string public name;
    string public symbol;
    uint256 private tokenIdCounter;
    string private baseURI;
    address private immutable owner;

    mapping(address => uint256) private balances;
    mapping(uint256 => address) private owners;
    mapping(uint256 => address) private tokenApproval;
    mapping(address => mapping(address => bool)) private operatorApproval;


    // ========== CONSTRUCTOR ==========
    constructor(string memory _name, string memory _symbol, string memory _baseURI) {
        name = _name;
        symbol = _symbol;
        baseURI = _baseURI;
        tokenIdCounter = 0;
        owner = msg.sender;
    }

    // ========== VIEW FUNCTIONS ==========
    
    function balanceOf(address _owner) public view returns(uint256) {
        if (_owner == address(0)) revert InvalidAddress();
        return balances[_owner];
    }

    function ownerOf(uint256 _tokenId) public view returns(address) {
        address nftOwner = owners[_tokenId];
        if (nftOwner == address(0)) revert TokenDoesNotExist();
        return nftOwner;
    }

    function getApproved(uint256 _tokenId) public view returns (address) {
        if (owners[_tokenId] == address(0)) revert TokenDoesNotExist();
        return tokenApproval[_tokenId];
    }

    function isApprovedForAll(address _owner, address _operator) public view returns (bool) {
        return operatorApproval[_owner][_operator];
    }

    function tokenURI(uint256 _tokenId) public view returns (string memory) {
        if (owners[_tokenId] == address(0)) revert TokenDoesNotExist();
        return string(abi.encodePacked(baseURI, _toString(_tokenId)));
    }

    // ========== APPROVAL FUNCTIONS ==========

    function approve(address _spender, uint256 _tokenId) public {
        address nftOwner = owners[_tokenId];
        if (nftOwner == address(0)) revert TokenDoesNotExist();
        if (msg.sender != nftOwner && !operatorApproval[nftOwner][msg.sender]) revert NotAuthorized();
        if (_spender == nftOwner) revert CannotApproveToCurrentOwner();
        
        tokenApproval[_tokenId] = _spender;
        emit Approval(nftOwner, _spender, _tokenId);
    }

    function setApprovalForAll(address _operator, bool _approved) public {
        if (_operator == msg.sender) revert CannotApproveSelf();
        operatorApproval[msg.sender][_operator] = _approved;
        emit ApprovalForAll(msg.sender, _operator, _approved);
    }

    // ========== TRANSFER FUNCTION ==========

    function transferFrom(address _from, address _to, uint256 _tokenId) public {
        if (!_isApprovedOrOwner(msg.sender, _tokenId)) revert NotAuthorized();
        if (owners[_tokenId] != _from) revert FromIsNotOwner();
        if (_to == address(0)) revert CannotTransferToZeroAddress();
        
        tokenApproval[_tokenId] = address(0);
        balances[_from] -= 1;
        balances[_to] += 1;
        owners[_tokenId] = _to;
        
        emit Transfer(_from, _to, _tokenId);
    }

    // ========== MINT & BURN ==========

    function mint(address _to) public returns (uint256) {
        if(msg.sender != owner) revert NotOwner();
        if (_to == address(0)) revert CannotMintToZeroAddress();
        
        tokenIdCounter++;
        uint256 tokenId = tokenIdCounter;
        
        balances[_to] += 1;
        owners[tokenId] = _to;
        
        emit Transfer(address(0), _to, tokenId);
        
        return tokenId;
    }

    function burn(uint256 _tokenId) public {
        address nftOwner = owners[_tokenId];
        if (nftOwner == address(0)) revert TokenDoesNotExist();
        if (msg.sender != nftOwner) revert NotOwner();
        
        tokenApproval[_tokenId] = address(0);
        balances[nftOwner] -= 1;
        delete owners[_tokenId];
        
        emit Transfer(nftOwner, address(0), _tokenId);
    }

    // ========== INTERNAL HELPERS ==========

    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
        address nftOwner = owners[tokenId];
        if (nftOwner == address(0)) revert TokenDoesNotExist();
        
        return (
            spender == nftOwner || 
            tokenApproval[tokenId] == spender ||
            operatorApproval[nftOwner][spender]
        );
    }

    function _toString(uint256 value) internal pure returns (string memory) {
        if (value == 0) return "0";
        
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        
        return string(buffer);
    }
}