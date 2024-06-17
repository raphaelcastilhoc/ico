//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract MutationSample50Score  {
    function add(uint256 firstValue, uint256 secondValue) public returns (uint256) {
        if(firstValue > secondValue) {
            uint256 result = firstValue + secondValue;
            return result;
        }
        else {
            uint256 result = firstValue == 0 ? secondValue + secondValue : firstValue;
            return result;
        }
    }
}