//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract InnerFunctionCallExternalFile {
    function inheritedInnerFunction(uint256 firstValue, uint256 secondValue) internal pure returns (bool) {
        if (firstValue > 0 && secondValue > 0) {
			return true;
		} else {
			return false;
		}
    }

    function innerExternalFunction(uint256 value, uint256 anotherValue) external pure returns (bool) {
        if (value > 100 || anotherValue > 100) {
			return true;
		} else {
			return false;
		}
    }
}