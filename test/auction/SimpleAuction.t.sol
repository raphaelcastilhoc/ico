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
    vm.startPrank(creator);

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

    function test_bid_SuccessfulBidWhenHighestBidIsNotZero() public {
    vm.startPrank(jill);

    simpleAuction.bid{value: 1 ether}();

    vm.stopPrank();

    vm.startPrank(chris);

    simpleAuction.bid{value: 2 ether}();

    vm.stopPrank();

    assert(simpleAuction.highestBid() == 2 ether);
    assert(simpleAuction.highestBidder() == chris);
}
}