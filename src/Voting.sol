// SPDX-License-Identifier: MIT

// Layout of Contract:
// version
// imports
// errors
// interfaces, libraries, contracts
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// view & pure functions

pragma solidity ^0.8.18;

contract Voting {

    //Error
    error Voting__NotOwner();
    error Voting__AlreadyVoted();
    error Voting__InvalidCandidateIndex();

    //structs
    struct Candidate {
        string name;
        uint256 amountOfVotes;
    }


    //state variable
    address private immutable i_owner;
    Candidate[] private candidates;
    mapping (address => bool ) private hasVoted;
    

    //events
    event CandidateAdded(string name);
    event Voted(address voter, uint256 candidateIndex);


    constructor(address _owner) {
        i_owner = _owner;
    }

    //modifier
    modifier onlyOwner {
        if(msg.sender != i_owner){
            revert Voting__NotOwner();
        }
        _;
    }

    function addCandidate(string memory _name) public onlyOwner {
       candidates.push(Candidate(_name, 0));
       emit CandidateAdded(_name);
    }

    function vote(uint256 index) public {

        if(hasVoted[msg.sender]){
            revert Voting__AlreadyVoted();
        }

        if(index > candidates.length){
            revert Voting__InvalidCandidateIndex();
        }
        
       candidates[index].amountOfVotes += 1;

       // add to the voters list
       hasVoted[msg.sender] = true;

       emit Voted(msg.sender, index);
    }

    function viewCandidates() public view returns (Candidate[] memory){
        return candidates;
    }
}


/// what i want my voting contract to do

//list of candidates
//candidate would be created in a struct to have name, and amount of votes
//users can only vote for one candidate
// users will be able to see total vote cast