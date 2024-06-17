//SPDX-License-Identifier: Unlicense
pragma solidity 0.8.19;

import "forge-std/Test.sol";
import "contracts/InvariantExample.sol";
import "./OlympixInvariantTest.sol";

contract InvariantExampleTest is OlympixInvariantTest("InvariantExample", "InvariantExampleHandler") {
    InvariantExample foo;

    function setUp() external {
        foo = new InvariantExample();
    }

    function invariant_A() external {
        assertEq(foo.val1() + foo.val2(), foo.val3());
    }

    function invariant_B() external {
        assertGe(foo.val1() + foo.val2(), foo.val1());
    }
}
