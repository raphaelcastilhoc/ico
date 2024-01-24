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

    function test_bid_FailWhenAuctionAlreadyEnded() public {
    vm.startPrank(jill);

    uint256 futureTimestamp = uint48(block.timestamp) + 8 days;
    vm.warp(futureTimestamp);

    vm.expectRevert(abi.encodeWithSelector(SimpleAuction.AuctionAlreadyEnded.selector));
    simpleAuction.bid{value: 1 ether}();
    
    vm.stopPrank();
}

    function test_bid_FailWhenBidIsNotHighEnough() public {
    vm.startPrank(jill);

    simpleAuction.bid{value: 2 ether}();

    vm.expectRevert(abi.encodeWithSelector(SimpleAuction.BidNotHighEnough.selector, 2 ether));
    simpleAuction.bid{value: 1 ether}();
    
    vm.stopPrank();
}

    function test_withdraw_FailWhenAmountIsZero() public {
    vm.startPrank(jill);

    bool result = simpleAuction.withdraw();
    assertTrue(result);

    vm.stopPrank();
}

    function test_auctionEnd_FailWhenAuctionNotYetEnded() public {
    vm.expectRevert(SimpleAuction.AuctionNotYetEnded.selector);
    simpleAuction.auctionEnd();
}
}