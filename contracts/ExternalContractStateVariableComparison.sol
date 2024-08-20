//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "./ExternalContractStateVariable.sol";
import "forge-std/Test.sol";

contract ExternalContractStateVariableComparison {
	ExternalContractStateVariable externalContract;

    constructor(){
        externalContract = new ExternalContractStateVariable();
    }

    function greaterThanExternalField(uint256 value) public view returns (bool) {
        if(value > externalContract.balance()) {
            return true;
        } else {
            return false;
        }
    }

    function senderIsOwnerComparison() public view returns (bool) {
        if(msg.sender == externalContract.owner()) {
            return true;
        } else {
            return false;
        }
    }

    function callingExternalFunctionComparingStateVariable(uint256 value) public returns (bool) {
        bool result = externalContract.isBalanceEnough(value);
        return result;
    }

    function senderIdIsInheritedOwnerIdComparison(bytes16 senderId) public view returns (bool) {
        if(senderId == externalContract.ownerId()) {
            return true;
        } else {
            return false;
        }
    }

    function callingExternalFunctionComparingInheritedStateVariable(bytes16 senderId) public returns (bool) {
        bool result = externalContract.isOwnerId(senderId);
        return result;
    }

    function validateMinValue(int value) public returns (bool) {
        bool result = externalContract.validateMinValue(value);
        return result;
    }

    function validateMaxValue(int value) public returns (bool) {
        if(value > externalContract.maxValue()) {
            return true;
        } else {
            return false;
        }
    }
}

contract ExternalContractStateVariableComparisonTest is Test {
    ExternalContractStateVariableComparison externalContractStateVariableComparison;

    function setUp() public {
        externalContractStateVariableComparison = new ExternalContractStateVariableComparison();
    }

    function test_greaterThanExternalField() public {
        bool result = externalContractStateVariableComparison.greaterThanExternalField(101);
        assertTrue(result);
    }

    function test_validateMinValue() public {
        bool result = externalContractStateVariableComparison.validateMinValue(1001);
        assertTrue(result);
    }
}