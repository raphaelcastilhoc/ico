//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "contracts/MutationSample50Score.sol";

contract MutationSample50ScoreTest is Test {
    MutationSample50Score mutationSample50Score;

    function setUp() public {
        mutationSample50Score = new MutationSample50Score();
    }

    function test_addSuccessfully() public {
        uint256 result = mutationSample50Score.add(10, 5);
        assertEq(result, 15);
    }
}