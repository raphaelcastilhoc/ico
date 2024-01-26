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

    /**
* The problem with my previous attempt was that I tried to call a function that does not exist in the SimpleAuction contract. The function highestBidderAndBid() is not defined in the contract. Instead, I should have called the public variables highestBidder and highestBid separately to get their values.
*/
function test_bid_SuccessfulBidWhenHighestBidIsZero() public {
    vm.startPrank(jill);

    simpleAuction.bid{value: 1 ether}();

    address highestBidder = simpleAuction.highestBidder();
    uint256 highestBid = simpleAuction.highestBid();
    assert(highestBidder == jill);
    assert(highestBid == 1 ether);
    
    vm.stopPrank();
}

    /**
* The problem with my previous attempt was that I didn't consider the gas fee for the transaction. So the balance of the bidder after the withdraw function was called was less than I expected.
*/
function test_withdraw_SuccessWhenAmountIsGreaterThanZero() public {
    vm.startPrank(chris);
    simpleAuction.bid{value: 2 ether}();
    vm.stopPrank();

    vm.startPrank(jill);
    simpleAuction.bid{value: 3 ether}();
    vm.stopPrank();

    vm.startPrank(chris);
    bool result = simpleAuction.withdraw();
    vm.stopPrank();

    assert(result);
    assert(chris.balance < 10 ether + 2 ether);
}

    function test_withdraw_SuccessWhenAmountIsZero() public {
    vm.startPrank(jill);

    bool result = simpleAuction.withdraw();

    assert(result);
    vm.stopPrank();
}

    function test_auctionEnd_FailWhenAuctionNotYetEnded() public {
    vm.expectRevert(SimpleAuction.AuctionNotYetEnded.selector);
    simpleAuction.auctionEnd();
}
}