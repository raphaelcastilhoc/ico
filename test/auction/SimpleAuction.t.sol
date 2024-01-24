// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "src/auction/SimpleAuction.sol";

contract SimpleAuctionTest is Test {
    address payable creator = payable(address(0x123));
    address jill = address(0x456);
    address chris = address(0x789);

    SimpleAuction simpleAuction;

    function setUp() public {
        vm.deal(creator, 10 ether);
        vm.deal(jill, 10 ether);
        vm.deal(chris, 10 ether);

        vm.startPrank(creator);
        simpleAuction = new SimpleAuction(7 days, creator);
        vm.stopPrank();
    }

    function test_auctionEnd_FailWhenAuctionNotYetEnded() public {
    vm.expectRevert(SimpleAuction.AuctionNotYetEnded.selector);
    simpleAuction.auctionEnd();
}
}