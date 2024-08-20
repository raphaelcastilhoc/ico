//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "./InnerFunctionCallExternalFile.sol";

contract InnerFunctionCall is InnerFunctionCallExternalFile {
    function callingInnerFunctionWithRequires(uint256 firstValue, uint256 secondValue) public view returns (uint256) {
        innerFunctionRequires(firstValue, secondValue);
        return firstValue + secondValue;
    }

    function innerFunctionRequires(uint256 value, uint256 anotherValue) private view {
        require(value > 0, "value must be greater than 0");
        require(anotherValue > 0, "anotherValue must be greater than 0");
    }

    function callingInnerFunctionWithConditional(uint256 firstValue, uint256 secondValue) public view returns (bool) {
        bool result = innerFunctionConditional(firstValue, secondValue);
        return result;
    }

    function innerFunctionConditional(uint256 firstValue, uint256 secondValue) private view returns (bool) {
        if (firstValue > 0 && secondValue > 0) {
			return true;
		} else {
			return false;
		}
    }

    function callingInnerFunctionWithLocalVariableAsArgument(int firstValue, int secondValue) public view returns (bool) {
        int sumResult = firstValue + secondValue;
        bool result = innerFunctionWithLocalVariableAsParameter(sumResult);
        return result;
    }

    function innerFunctionWithLocalVariableAsParameter(int sumValue) private view returns (bool) {
        if (sumValue > 100) {
			return true;
		} else {
			return false;
		}
    }

    function callingInnerFunctionWithArithmeticExpressionInside(int firstValue, int secondValue) public view returns (bool) {
        bool result = innerFunctionWithArithmeticExpressionInside(firstValue, secondValue);
        return result;
    }

    function innerFunctionWithArithmeticExpressionInside(int value, int anotherValue) private view returns (bool) {
        int sumValue = value + anotherValue;
        if (sumValue > 200) {
			return true;
		} else {
			return false;
		}
    }

    function callingInnerFunctionInsideAnotherInnerFunction(int firstValue, int secondValue) public view returns (bool) {
        bool result = innerFunctionCallingAnotherInnerFunction(firstValue, secondValue);
        return result;
    }

    function innerFunctionCallingAnotherInnerFunction(int value, int anotherValue) private view returns (bool) {
        int sumValue = value + anotherValue;
        bool result = deeperInnerFunction(sumValue);
        return result;
    }

    function deeperInnerFunction(int sumValue) private view returns (bool) {
        if (sumValue > 500) {
			return true;
		} else {
			return false;
		}
    }

    function callingInheritedInnerFunction(uint256 value, uint256 anotherValue) public view returns (bool) {
        bool result = inheritedInnerFunction(value, anotherValue);
        return result;
    }
}