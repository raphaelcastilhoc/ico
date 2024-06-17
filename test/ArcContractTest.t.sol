// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.19;

import "forge-std/Test.sol";
import "contracts/ArcContract.sol";

contract ArcContractTest is Test {
    ArcContract arcContract;

    function setUp() public {
        arcContract = new ArcContract();
    }

    function test_checkWhenValueIsGreaterThan100AndShouldIncrement() public {
        uint256 result = arcContract.check(101, true);
        assertEq(result, 4);
    }

    function test_checkWhenValueIsLessThan100AndShouldNotIncrement() public {
        uint256 result = arcContract.check(99, false);
        assertEq(result, 1);
    }

    function test_checkWhenValueIsGreaterThan100AndShouldNotIncrement() public {
        uint256 result = arcContract.check(101, false);
        assertEq(result, 2);
    }

    function test_checkWhenValueIsLessThan100AndShouldIncrement() public {
        uint256 result = arcContract.check(99, true);
        assertEq(result, 3);
    }
}
