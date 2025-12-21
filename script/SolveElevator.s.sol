// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {GoToTop} from "../src/Elevator.sol";

contract SolveElevator is Script {
    GoToTop public go;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        go = new GoToTop((vm.envAddress("ELEVATOR_ADDRESS")));
        go.gogogo();
        vm.stopBroadcast();
    }
}
