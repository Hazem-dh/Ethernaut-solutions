// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {CoinFlip,CoinFlipSolver} from "../src/Coinflip.sol";

contract SolveCoinFlip is Script {
    uint256 constant FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();
        // Deploy the CoinFlipSolver contract
        //CoinFlipSolver coinFlip = new CoinFlipSolver(vm.envAddress("COINFLIP_ADDRESS"));
        // Use the already deployed CoinFlipSolver contract address
        CoinFlipSolver coinFlip =  CoinFlipSolver(0xa9b538E078A913017a89F28A6BA82b14EFaBbA09);

        // Call flip with the correct guess
        coinFlip.flipsolve();
        uint256 conflictiveWins = coinFlip.consecutiveWins();
        console.log("Consecutive Wins:", conflictiveWins);

        vm.stopBroadcast();
    }
}
