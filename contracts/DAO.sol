// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./WickedToken.sol";
import "./User.sol";
import "./Activities.sol";



contract DAO is User, WickedToken, Activities {
    
    constructor() {}

    function registerSponsor() public payable returns(bool) {
        require(msg.value > 2000000000000000000, "less than 2 ETH sent" );
        _registerSponsor(msg.sender);
        mint(msg.sender, 2000);
        return true;
    }

    function registerNewUser(address _userAddress) public {
        _registerNewUser(_userAddress);
    }

    function promoteUserToCoach(address _userAddress) public {
        _promoteUsertoCoach(_userAddress);
        
    }

    function createActivity(string memory _activityName, string memory _activityDescription, uint256 _fundingGoal) public onlyRole(COACH) {
        _createActivity(_activityName, _activityDescription, _fundingGoal, msg.sender);
    }

    function fundActivity(uint256 _numberOfTokens, uint256 _activityId) public onlyRole(SPONSOR) {
        require(balanceOf(msg.sender) >= _numberOfTokens, "Insufficient tokens");
        require(_getFundGoal(_activityId) == _numberOfTokens, "Tokens do not match fund goal");
        increaseAllowance(msg.sender, _numberOfTokens);
        transferFrom(msg.sender, address(this), _numberOfTokens);

        // allow the coach to mark activity completed
        Activity memory currentActivity = activities[_activityId];
        _approve(address(this), currentActivity.coach, _numberOfTokens);

        _updateActivityFunded(_activityId);
    }

    function optInActivity(uint256 _activityId) public onlyRole(ASPIRANT) {
        _assignAspirantToActivity(_activityId, msg.sender);
    }


    function completeActivity(uint256 _activityId) public {
        // send out 1 token to each aspirant and 1 token to the coach, balance funds to the sponsor
        Activity memory currentActivity = activities[_activityId];
        uint256 balance = currentActivity.fundingGoal;

        uint256 coachCut = balance * 10 / 100;
        uint256 aspirantCut = balance * 6 / 100;
        
        transferFrom(address(this), currentActivity.coach, coachCut);
        balance-=1;
        
        uint arrayLength = currentActivity.aspirants.length;
        for (uint i=0; i<arrayLength; i++) {
            transferFrom(address(this), currentActivity.aspirants[i], aspirantCut);
            balance-=1;
        } 

        transferFrom(address(this), currentActivity.sponsor, balance);

        _updateActivityCompleted(_activityId);
    }

}
