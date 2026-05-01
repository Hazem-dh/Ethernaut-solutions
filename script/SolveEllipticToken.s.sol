// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Script, console} from "forge-std/Script.sol";
import {EllipticToken} from "../src/EllipticToken.sol";

contract SolveEllipticToken is Script {
    function run() public {
        address instanceAddr = vm.envAddress("ELLIPACTIC_TOKEN_ADDRESS");
        address aliceAddr = 0xA11CE84AcB91Ac59B0A4E2945C9157eF3Ab17D4e;

        EllipticToken token = EllipticToken(instanceAddr);

        vm.startBroadcast();

        address playerAddr = msg.sender;
        uint256 aliceBalance = token.balanceOf(aliceAddr);

        uint256 amount = uint256(
            0xebf90284f84cb6e234a8ecf9393afda9c0ede46f4d6df12bd11a4757c42903c0
        );

        bytes
            memory tokenOwnerSignature = hex"0ab5b8262a97582b1971d68211e37be02ac5d16339cb0278edffc0a465d64aac"
            hex"7b06ed5cd7bc5798089feda2fac7b577ef49e1f2f84a6d2392ff26078f2192a01c";

        bytes32 permitAcceptHash = keccak256(
            abi.encodePacked(aliceAddr, playerAddr, amount)
        );
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(playerAddr, permitAcceptHash);
        bytes memory spenderSignature = abi.encodePacked(r, s, v);

        token.permit(amount, playerAddr, tokenOwnerSignature, spenderSignature);

        token.transferFrom(aliceAddr, playerAddr, aliceBalance);

        vm.stopBroadcast();
    }
}
