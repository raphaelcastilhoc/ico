//SPDX-License-Identifier: Unlicense
pragma solidity 0.8.19;

import "forge-std/Test.sol";
import "contracts/Counter.sol";

contract CounterTest is Test {
    Counter counter;

    function setUp() public {
        counter = new Counter();
    }

    function test_updateDetails() public {
        counter.updateDetails(11, "Updated Name");
        assertEq(counter.name(), "Updated Name");
        assertEq(counter.count(), 11);
    }
}