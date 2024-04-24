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

    function test_withdraw_SuccessfulWithdraw() public {
        vm.startPrank(bob);
        simpleAuction.bid{value: 100}();
        vm.stopPrank();
    
        vm.startPrank(alice);
        simpleAuction.bid{value: 200}();
        vm.stopPrank();
    
        vm.startPrank(bob);
        bool result = simpleAuction.withdraw();
        vm.stopPrank();
    
    //    assertEq(result, true);
    //    assertEq(bob.balance, 1100);
    }
    

    function test_withdraw_FailWhenThereIsNoAmountToWithdraw() public {
        vm.startPrank(alice);
    
        bool result = simpleAuction.withdraw();
    
        assertEq(result, true);
    
        vm.stopPrank();
    }

    function test_auctionEnd_FailWhenAuctionNotYetEnded() public {
        vm.startPrank(alice);
    
        vm.expectRevert(SimpleAuction.AuctionNotYetEnded.selector);
        simpleAuction.auctionEnd();
    
        vm.stopPrank();
    }

    function test_auctionEnd_FailWhenAuctionEndAlreadyCalled() public {
        vm.startPrank(bob);
    
        simpleAuction.bid{value: 100}();
    
        vm.warp(7 days + 1);
    
        simpleAuction.auctionEnd();
    
        vm.expectRevert(SimpleAuction.AuctionEndAlreadyCalled.selector);
        simpleAuction.auctionEnd();
    
        vm.stopPrank();
    }
}