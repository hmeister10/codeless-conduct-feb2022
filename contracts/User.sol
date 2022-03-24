// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/AccessControl.sol";


contract User is AccessControl {
    
    mapping(address => string) users;
    mapping(address => bool) kycCompleted;
    bytes32 public constant SPONSOR = keccak256("SPONSOR");
    bytes32 public constant STEWARD = keccak256("STEWARD");
    bytes32 public constant COACH = keccak256("COACH");
    bytes32 public constant ASPIRANT = keccak256("ASPIRANT");

    constructor() {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    function _registerSponsor(address _userAddress) internal {
        kycCompleted[_userAddress] = true;
        _grantRole(SPONSOR, _userAddress);        
    }

    function _registerNewUser(address _userAddress) internal {
        kycCompleted[_userAddress] = true;
        _grantRole(ASPIRANT, _userAddress);        
    }

    function _promoteUsertoCoach(address _userAddress) internal {
        _revokeRole(ASPIRANT, _userAddress);
        _grantRole(COACH, _userAddress);
    }

    // function register(address _userAddress, string memory _userType) public returns(bool){
    //     users[_userAddress] = _userType;
    //     kycCompleted[_userAddress] = true;

    //     if(_userType == "") 
    //     _grantRole(MINTER_ROLE, _userAddress);

    //     return true;
    // }

    function isKycCompleted(address _addr) public view returns(bool) {
        return kycCompleted[_addr];
    }

}
