//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "contracts/MutationSampleContract.sol";

contract MutationSampleContractTest is Test {
    MutationSampleContract mutationSampleContract;

    function setUp() public {
        mutationSampleContract = new MutationSampleContract();
    }

    function test_addWhenIsEnabled() public {
        uint256 result = mutationSampleContract.add(10, 5);
        assertEq(result, 15);
    }

    function test_addWhenIsDisabledAndSecondValueIsZero() public {
        mutationSampleContract.setIsEnabled(false);
        uint256 result = mutationSampleContract.add(10, 0);
        assertEq(result, 11);
    }

    function test_addWhenIsDisabledAndFirstValueIsZero() public {
        mutationSampleContract.setIsEnabled(false);
        uint256 result = mutationSampleContract.add(0, 5);
        assertEq(result, 1);
    }

    function test_addWhenIsDisabledAndFirstAndSecondValueAreNotZero() public {
        mutationSampleContract.setIsEnabled(false);
        uint256 result = mutationSampleContract.add(10, 5);
        assertEq(result, 10);
    }

    function test_subtractSuccessfully() public {
        uint256 result = mutationSampleContract.subtract(10, 5);
        assertEq(result, 5);
    }

    function test_subtractFailWhenFirstValueIsZero() public {
        vm.expectRevert("firstValue must be greater than 0");
        uint256 result = mutationSampleContract.subtract(0, 5);
    }

    function test_subtractFailWhenSecondValueIsGreaterThanFirstValue() public {
        vm.expectRevert("secondValue must be less than firstValue");
        uint256 result = mutationSampleContract.subtract(5, 10);
    }

    function test_subtractFailWhenIsDisabled() public {
        mutationSampleContract.setIsEnabled(false);
        vm.expectRevert("It is disabled");
        uint256 result = mutationSampleContract.subtract(10, 5);
    }
}