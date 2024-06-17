//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract ArcContract {
    function check(uint256 value, bool shouldIncrement) public returns (uint256) {
        uint256 returnValue = 0;
        if(value > 100) {
            returnValue = 3;
        } else {
            returnValue = 2;
        }

        if(shouldIncrement) {
            returnValue += 1;
        } else {
            returnValue -= 1;
        }

        return returnValue;
    }
}
