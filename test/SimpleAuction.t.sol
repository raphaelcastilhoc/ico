//SPDX-License-Identifier: Unlicense
pragma solidity 0.8.19;

import "forge-std/Test.sol";
import "contracts/SimpleAuction.sol";
import "./OlympixUnitTest.sol";

contract SimpleAuctionTest is OlympixUnitTest("SimpleAuction") {
    address alice = address(0x456);
    address bob = address(0x789);
    address payable beneficiary = payable(address(0xff));
    SimpleAuction simpleAuction;

    function setUp() public {
        simpleAuction = new SimpleAuction(7 days, beneficiary);

        vm.deal(alice, 1000);
        vm.deal(bob, 1000);
    }
}