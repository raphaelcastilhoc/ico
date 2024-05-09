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

    function test_bid_FailWhenAuctionIsEnded() public {
        vm.startPrank(alice);
    
        uint256 futureTimestamp = uint48(block.timestamp) + 8 days;
        vm.warp(futureTimestamp);
    
        vm.expectRevert(SimpleAuction.AuctionAlreadyEnded.selector);
        simpleAuction.bid{value: 100}();
    
        vm.stopPrank();
    }

    function test_bid_FailWhenBidIsNotHighEnough() public {
        vm.startPrank(alice);
    
        simpleAuction.bid{value: 100}();
    
        vm.startPrank(bob);
    
        vm.expectRevert(abi.encodeWithSelector(SimpleAuction.BidNotHighEnough.selector, 100));
        simpleAuction.bid{value: 100}();
    
        vm.stopPrank();
    
        vm.stopPrank();
    }

    function test_withdraw_SuccessfulWithdraw() public {
        vm.startPrank(bob);
    
        simpleAuction.bid{value: 200}();
    
        vm.stopPrank();
    
        vm.startPrank(alice);
    
        simpleAuction.bid{value: 300}();
    
        vm.stopPrank();
    
        vm.startPrank(bob);
    
        bool result = simpleAuction.withdraw();
    
        vm.stopPrank();
    
        assertEq(bob.balance, 1000);
        assert(result);
    }

    function test_withdraw_SuccessfulWhenThereIsNothingToWithdraw() public {
        vm.startPrank(alice);
    
        bool result = simpleAuction.withdraw();
    
        vm.stopPrank();
    
        assert(result);
    }

    function test_auctionEnd_FailWhenAuctionIsNotEnded() public {
        vm.startPrank(beneficiary);
    
        vm.expectRevert(SimpleAuction.AuctionNotYetEnded.selector);
        simpleAuction.auctionEnd();
    
        vm.stopPrank();
    }

    function test_auctionEnd_FailWhenAuctionIsAlreadyEnded() public {
        vm.startPrank(beneficiary);
    
        uint256 futureTimestamp = uint48(block.timestamp) + 8 days;
        vm.warp(futureTimestamp);
    
        simpleAuction.auctionEnd();
    
        vm.expectRevert(SimpleAuction.AuctionEndAlreadyCalled.selector);
        simpleAuction.auctionEnd();
    
        vm.stopPrank();
    }
}