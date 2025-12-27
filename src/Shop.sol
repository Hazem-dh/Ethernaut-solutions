// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IBuyer {
    function price() external view returns (uint256);
}

contract Shop {
    uint256 public price = 100;
    bool public isSold;

    function buy() public {
        IBuyer _buyer = IBuyer(msg.sender);

        if (_buyer.price() >= price && !isSold) {
            isSold = true;
            price = _buyer.price();
        }
    }
}

contract Buyer {
    Shop shop;

    constructor(address _shopAddress) {
        shop = Shop(_shopAddress);
    }

    function buy() public {
        shop.buy();
    }

    function price() external view returns (uint256) {
        if (shop.isSold()) return 0;
        else return 100;
    }
}
