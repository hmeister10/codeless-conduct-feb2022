// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import "@openzeppelin/contracts/utils/Counters.sol";

contract Activities {

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    enum ActivityStatus {
        CREATED,
        FUNDED,
        STARTED,
        COMPLETED
    }

    struct Activity {
        string name;
        string description;
        ActivityStatus status;
        uint fundingGoal;
        address payable coach;
        address payable[] aspirants;
        address payable sponsor;
    }
    
    mapping(uint256 => Activity) public activities;

    constructor() {

    }

    function _createActivity(string memory _activityName, string memory _activityDescription, uint256 _fundingGoal, address _coach) internal returns(uint256) {
        uint256 tokenId = _tokenIdCounter.current();
        
        _tokenIdCounter.increment();
        
        address payable[] memory aspirantsArray;
        address blank = address(0);
        
        activities[tokenId] = Activity(
            _activityName, 
            _activityDescription, 
            ActivityStatus.CREATED, 
            _fundingGoal, 
            payable(_coach),
            aspirantsArray,
            payable(blank));
        return tokenId;
    }

    function _getFundGoal(uint256 _activityId) internal view returns(uint) {
        return activities[_activityId].fundingGoal;
    }

    function _updateActivityFunded(uint256 _activityId) internal {
        activities[_activityId].status = ActivityStatus.FUNDED;
        activities[_activityId].sponsor = payable(msg.sender);
    }

     function _updateActivityCompleted(uint256 _activityId) internal {
        activities[_activityId].status = ActivityStatus.COMPLETED;
    }

    function _assignAspirantToActivity(uint256 _activityId, address _userAddress) internal {
        activities[_activityId].aspirants.push(payable(_userAddress));
    }


}
