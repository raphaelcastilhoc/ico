//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "./InnerFunctionCallExternalFile.sol";
import "forge-std/Test.sol";

contract InnerFunctionCallInConstructor {
	uint256 private totalBalance;
	bool private isActive;

	InnerFunctionCallExternalFile innerFunctionCallExternalFile;

	constructor(uint256 initialBalance, bool _isActive) {
		initialize(initialBalance, _isActive);
		innerFunctionCallExternalFile = new InnerFunctionCallExternalFile();
	}

	function initialize(uint256 initialBalance, bool _isActive) private {
		require(initialBalance > 0, "Initial balance must be greater than 0");

		totalBalance = initialBalance;
		isActive = _isActive;
	}

	function callingInnerFunctioFromAnotherContract(uint256 firstValue, uint256 secondValue) public view returns (bool) {
        bool result = innerFunctionCallExternalFile.innerExternalFunction(firstValue, secondValue);
        return result;
    }
}

contract InnerFunctionCallInConstructorTest is Test {
    InnerFunctionCallInConstructor innerFunctionCallInConstructor;

    function setUp() public {
        innerFunctionCallInConstructor = new InnerFunctionCallInConstructor(1, true);
    }

    function test_externalFunction() public {
        bool result = innerFunctionCallInConstructor.callingInnerFunctioFromAnotherContract(101, 1);
        assertTrue(result);
    }
}