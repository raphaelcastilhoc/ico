//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract TheoremProving  {

    // bool public shouldDoOperation = true;

    function add(uint256 firstValue, uint256 secondValue) public returns (uint256) {
        if(firstValue > secondValue) {
            return firstValue + secondValue;
        } else {
            return firstValue + firstValue;
        }
    }

    function sub(uint256 firstValue, uint256 secondValue) public pure returns (uint256) {
        if(firstValue < secondValue) {
            return secondValue - firstValue;
        } else {
            return firstValue - secondValue;
        }
    }

    function logicalComparisonAdd(uint256 firstValue, uint256 secondValue, uint256 minValue) public pure returns (uint256) {
        if(firstValue > minValue && firstValue >= secondValue) {
            return firstValue + secondValue;
        } else {
            return firstValue + minValue;
        }
    }

    function internalVariableAdd(uint256 firstValue, uint256 secondValue, uint256 minValue) public pure returns (uint256) {
        uint256 result = firstValue + secondValue;

        if(result < minValue) {
            return minValue;
        } else {
            return result;
        }
    }

    function internalVariableWithLogicalComparison(uint256 firstValue, uint256 secondValue, uint256 minValue) public pure returns (uint256) {
        uint256 result = firstValue + secondValue;

        if(result > minValue && firstValue > secondValue) {
            return minValue;
        } else {
            return result;
        }
    }

    function internalSubtractionVariableWithLogicalComparison(uint256 firstValue, uint256 secondValue, uint256 minValue) public pure returns (uint256) {
        uint256 result = firstValue - secondValue;

        if(result < minValue && firstValue < minValue) {
            return minValue;
        } else {
            return result;
        }
    }

    function multipleLogicalComparisonAdd(uint256 firstValue, uint256 secondValue, uint256 minValue) public pure returns (uint256) {
        uint256 result = 0;

        if(firstValue < secondValue && firstValue < minValue) {
            result = firstValue + secondValue;
        } else {
            result = firstValue + minValue;
        }

        if(secondValue > firstValue && secondValue > minValue) {
            result = secondValue + result;
        }

        return result;
    }

    function multipleLogicalComparisonWithDifferentResult(uint256 firstValue, uint256 secondValue, uint256 minValue) public pure returns (uint256) {
        uint256 result = 0;

        if(firstValue < secondValue && firstValue > minValue) {
            result = firstValue + secondValue;
        } else {
            result = firstValue + minValue;
        }

        if(secondValue > firstValue && result > minValue) {
            result = secondValue + result;
        }

        return result;
    }

    function internalVariableAndLogicalComparisonAdd(uint256 firstValue, uint256 secondValue, uint256 minValue) public pure returns (uint256) {
        uint256 result = firstValue + secondValue;

        if(result > minValue && firstValue > secondValue) {
            result = firstValue + secondValue;
        } else {
            result = firstValue + firstValue;
        }

        if(result > minValue) {
            result = result + minValue;
        }

        return result;
    }





    // function globalFieldAdd(uint256 firstValue, uint256 secondValue) public pure returns (uint256) {
    //     if(shouldDoOperation) {
    //         return firstValue + secondValue;
    //     } else {
    //         return firstValue;
    //     }
    // }

    // function callingPrivateAdd(uint256 firstValue, uint256 secondValue) public pure returns (uint256) {
    //     privateAdd(firstValue, secondValue);
    // }

    // function privateAdd(uint256 firstValue, uint256 secondValue) private pure returns (uint256) {
    //     if(firstValue > secondValue) {
    //         return firstValue + secondValue;
    //     } else {
    //         return privateExternalAdd(firstValue);
    //     }
    // }

    // function arithmeticInsideLogicalComparison(uint256 firstValue, uint256 secondValue, uint256 minValue) public pure returns (uint256) {
    //     uint256 result = firstValue - secondValue;

    //     if(result < (minValue + secondValue) && firstValue < secondValue) {
    //         return minValue;
    //     } else {
    //         return result;
    //     }
    // }


    //Write method which handles complex object
}