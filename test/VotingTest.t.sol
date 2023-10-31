// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {Voting} from "../src/Voting.sol";
import "../script/DeployVoting.s.sol";

contract VotingTest is Test {
    DeployVoting deployer;
    Voting voting;
    address public USER = makeAddr("user");
    address private OWNER;

    function setUp() public {       
       deployer = new DeployVoting();
       voting = deployer.run();
       OWNER = voting.getOwner();
    }

    
    function testAddCandidateFailedIfNotOwner() public {
        string memory candidateName = "ikenna";
        vm.prank(USER);
        vm.expectRevert();
        voting.addCandidate(candidateName);
    }

    function testOnlyOwnerCanAddCandidateAndInfoIsCorrect() public {
        vm.prank(OWNER);
        string memory candidateName = "ikenna";
        voting.addCandidate(candidateName);
        assertEq(candidateName, voting.viewCandidates()[0].name);
    }

    function testThatVotingFailsIfNoCandidateHasBeenAdded() public {
        vm.prank(USER);
        vm.expectRevert();
        voting.vote(0);
    }

    modifier candidateAdded {
        vm.prank(OWNER);
        string memory candidateName = "ikenna";
        voting.addCandidate(candidateName);
        _;
    }

    function testThatUserCanVote() public candidateAdded {
        vm.prank(USER);
        voting.vote(0);
    }

    function testThatVoterCantVoteTwice() public candidateAdded {
        vm.prank(USER);
        voting.vote(0);

        //try to vote again
        vm.prank(USER);
        vm.expectRevert();
        voting.vote(0);
        
    }

    function testIfWeHaveAnEmptyListOfCandidatesInitially() public {
        assertEq(0, voting.viewCandidates().length);
    }

    function testIfWeHaveTheSameAmountOfCandidatesWeAdded() public {
        vm.prank(OWNER);
        string memory candidate1 = "ikenna";
        voting.addCandidate(candidate1);

        vm.prank(OWNER);
        string memory candidate2 = "aces";
        voting.addCandidate(candidate2);

        assertEq(2, voting.viewCandidates().length);
    }

    function testThatUsersCantVoteForACandidateNotOnTheBallot() public {
        vm.prank(USER);
        vm.expectRevert();
        voting.vote(0);
    }

    function testThatTheAmountOfVotesIncreaseWhenASuccessfulVoteHappens() public {
        vm.prank(OWNER);
        string memory candidate1 = "ikenna";
        voting.addCandidate(candidate1);

        vm.prank(USER);
        voting.vote(0);

        assertEq(1, voting.viewCandidates()[0].amountOfVotes);

    }

    
   
}