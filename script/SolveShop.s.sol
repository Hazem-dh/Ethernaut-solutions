// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {Buyer, Shop} from "../src/Shop.sol";

contract SolveShop is Script {
    function setUp() public {}

    function run() public {
        vm.startBroadcast();
        Shop shop = Shop(vm.envAddress("SHOP_ADDRESS"));
        Buyer buyer = new Buyer(address(shop));
        buyer.buy();
        vm.stopBroadcast();
    }
}
