//SPDX-License-Identifier: Unlicense
pragma solidity 0.8.19;

import "forge-std/Test.sol";
import "contracts/SimpleCoin.sol";
import "./OlympixUnitTest.sol";

contract SimpleCoinTest is OlympixUnitTest("SimpleCoin") {
    address alice = address(0x456);
    address bob = address(0x789);
    address owner = address(0xff);
    SimpleCoin simpleCoin;

    function setUp() public {
        vm.startPrank(owner);
        simpleCoin = new SimpleCoin(owner);
        vm.stopPrank();

        deal(address(simpleCoin), alice, 1000);
        deal(address(simpleCoin), bob, 1000);
    }
}