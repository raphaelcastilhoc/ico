//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "contracts/BlindAuction.sol";
import "./OlympixUnitTest.sol";

contract BlindAuctionTest is OlympixUnitTest("BlindAuction") {
    address beneficiary = address(0x123);
    address regan = address(0x456);
    address chris = address(0x789);

    BlindAuction blindAuction;

    function setUp() public {
        vm.deal(beneficiary, 100 ether);
        vm.deal(regan, 100 ether);
        vm.deal(chris, 100 ether);

        vm.startPrank(beneficiary);
        blindAuction = new BlindAuction(7 days, 2 days, payable(beneficiary));
        vm.stopPrank();
    }
}