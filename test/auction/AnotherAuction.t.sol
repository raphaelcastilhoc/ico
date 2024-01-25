pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "src/auction/AnotherAuction.sol";

contract AnotherAuctionTest is Test {
    address payable creator = payable(address(0x123));
    address jill = address(0x456);
    address chris = address(0x789);

    AnotherAuction anotherAuction;

    function setUp() public {
        vm.deal(creator, 10 ether);
        vm.deal(jill, 10 ether);
        vm.deal(chris, 10 ether);

        vm.startPrank(creator);
        anotherAuction = new AnotherAuction(7 days, creator);
        vm.stopPrank();
    }

    function test_anotherBid_FailWhenAuctionAlreadyEnded() public {
    vm.startPrank(creator);

    uint256 futureTimestamp = uint48(block.timestamp) + 8 days;
    vm.warp(futureTimestamp);

    vm.expectRevert(AnotherAuction.AuctionAlreadyEnded.selector);
    anotherAuction.anotherBid{value: 1 ether}();

    vm.stopPrank();
}

    function test_anotherBid_FailWhenBidIsNotHighEnough() public {
    vm.startPrank(jill);

    anotherAuction.anotherBid{value: 2 ether}();

    vm.expectRevert(abi.encodeWithSelector(AnotherAuction.BidNotHighEnough.selector, 2 ether));
    anotherAuction.anotherBid{value: 1 ether}();

    vm.stopPrank();
}

    function test_anotherBid_SuccessfulBidWhenHighestBidIsNotZero() public {
    vm.startPrank(jill);

    anotherAuction.anotherBid{value: 1 ether}();

    vm.startPrank(chris);

    anotherAuction.anotherBid{value: 2 ether}();

    assert(anotherAuction.highestBid() == 2 ether);
    assert(anotherAuction.highestBidder() == chris);

    vm.stopPrank();
}
}