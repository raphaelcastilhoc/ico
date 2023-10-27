
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "contracts/SpaceCoin.sol";

contract SpaceCoinTest is Test {
    
    // initialize external users as 
    address alice = address(0xff);
    address bob = address(0x2);
    address owner = address(0x3);
    address treasury = address(0x4);
    SpaceCoin spaceCoin;

    function setUp() public {
        vm.deal(alice, 1000);
        vm.deal(bob, 1000);
        vm.startPrank(owner);
        spaceCoin = new SpaceCoin(treasury, owner);
        vm.stopPrank();
    }

    /* TEST_FUNCTIONS_HERE */
}