// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {DoubleEntryPoint, CryptoVault, Forta, IDetectionBot, LegacyToken} from "../src/DoubleEntryPoint.sol";

// Detection bot that prevents vault from being drained
contract VaultDetectionBot is IDetectionBot {
    address public cryptoVault;

    constructor(address _cryptoVault) {
        cryptoVault = _cryptoVault;
    }

    function handleTransaction(address user, bytes calldata msgData) external override {
        address origSender;
        assembly {
            origSender := calldataload(add(msgData.offset, 68))
        }

        // If the origSender is the vault, raise an alert
        if (origSender == cryptoVault) Forta(msg.sender).raiseAlert(user);
    }
}

contract SolveDoubleEntryPoint is Script {
    DoubleEntryPoint public det;
    CryptoVault public vault;
    LegacyToken public legacyToken;
    Forta public forta;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        // Get the DoubleEntryPoint contract
        address detAddress = vm.envAddress("DOUBLEENTRYPOINT_ADDRESS");
        det = DoubleEntryPoint(detAddress);

        // Get other contract addresses
        vault = CryptoVault(det.cryptoVault());
        legacyToken = LegacyToken(det.delegatedFrom());
        forta = det.forta();

        // Deploy our detection bot
        VaultDetectionBot bot = new VaultDetectionBot(address(vault));

        // Register the detection bot with Forta
        forta.setDetectionBot(address(bot));

        // Verify registration
        address registeredBot = address(forta.usersDetectionBots(msg.sender));

        vm.stopBroadcast();
    }
}
