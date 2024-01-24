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

    function test_bid_FailWhenBidIsNotHighEnough() public {
    vm.startPrank(jill);

    simpleAuction.bid{value: 1 ether}();

    vm.expectRevert(abi.encodeWithSelector(SimpleAuction.BidNotHighEnough.selector, 1 ether));
    simpleAuction.bid{value: 1 ether}();
    
    vm.stopPrank();
}

    function test_withdraw_SuccessfulWithdraw() public {
    vm.startPrank(jill);

    simpleAuction.bid{value: 2 ether}();

    vm.startPrank(chris);

    simpleAuction.bid{value: 3 ether}();

    vm.startPrank(jill);

    bool result = simpleAuction.withdraw();
    
    vm.stopPrank();

    assertTrue(result);
    assertEq(jill.balance, 10 ether);
}

    function test_withdraw_FailWhenAmountIsZero() public {
    vm.startPrank(jill);

    bool result = simpleAuction.withdraw();
    
    vm.stopPrank();

    assertTrue(result);
}

    function test_auctionEnd_FailWhenAuctionNotYetEnded() public {
    vm.expectRevert(SimpleAuction.AuctionNotYetEnded.selector);
    simpleAuction.auctionEnd();
}
}