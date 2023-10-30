// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {Voting} from "../src/Voting.sol";

contract DeployVoting is Script{

    function run() external returns (Voting,address) {
        vm.startBroadcast();
        Voting voting = new Voting(msg.sender);
        vm.stopBroadcast();
        return (voting, msg.sender);
    }
    
}