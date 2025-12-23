// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {MagicNum} from "../src/MagicNumber.sol";

contract SolveMagicNumber is Script {
    MagicNum public magicNum;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();
        magicNum = MagicNum(payable(vm.envAddress("MAGICNUMBER_ADDRESS")));
        // we deploy the contract that returns 42 when called
        bytes
            memory deploymentBytecode = hex"69602a60005260206000f3600052600a6016f3";

        address minimalContractAddress;
        assembly {
            minimalContractAddress := create(
                0,
                add(deploymentBytecode, 0x20),
                mload(deploymentBytecode)
            )
        }
        magicNum.setSolver(minimalContractAddress);
        vm.stopBroadcast();
    }
}
