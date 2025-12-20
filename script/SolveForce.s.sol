// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {Force, Solver} from "../src/Force.sol";

contract SolveForce is Script {
    Solver public forceContract;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();
        forceContract = new Solver{value: 0.001 ether}(vm.envAddress("FORCE_ADDRESS"));
        forceContract.destroyAndSend();
        vm.stopBroadcast();
    }
}
