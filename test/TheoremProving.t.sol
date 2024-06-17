//SPDX-License-Identifier: Unlicense
pragma solidity 0.8.19;

import "forge-std/Test.sol";
import "contracts/TheoremProving.sol";
import "./OlympixUnitTest.sol";

contract TheoremProvingTest is OlympixUnitTest("TheoremProving") {
    TheoremProving theoremProving;

    function setUp() public {
        theoremProving = new TheoremProving();
    }
}
