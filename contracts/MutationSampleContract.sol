//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract MutationSampleContract  {

    bool public isEnabled = true;

    modifier onlyValidParameters(uint256 firstValue, uint256 secondValue) {
        require(firstValue > 0, "firstValue must be greater than 0");
        require(secondValue < firstValue, "secondValue must be less than firstValue");
        _;
    }

    modifier onlyWhenIsEnabled() {
        require(isEnabled == true, "It is disabled");
        _;
    }

    function setIsEnabled(bool _isEnabled) public {
        isEnabled = _isEnabled;
    }

    function add(uint256 firstValue, uint256 secondValue) public returns (uint256) {
        if(isEnabled) {
            uint256 result = firstValue + secondValue;
            return result;
        }

        if(!isEnabled && secondValue == 0) {
            firstValue += 1;
            return firstValue;
        }

        uint256 result = firstValue == 0 ? 1 : firstValue;
        return result;
    }

    function subtract(uint256 firstValue, uint256 secondValue) public onlyValidParameters(firstValue, secondValue)
     onlyWhenIsEnabled returns (uint256) {
        return firstValue - secondValue;
    }
}