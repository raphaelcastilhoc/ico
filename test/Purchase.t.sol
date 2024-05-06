//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "contracts/Purchase.sol";
import "./OlympixUnitTest.sol";

contract PurchaseTest is OlympixUnitTest("Purchase") {
    address alice = address(0x456);
    address bob = address(0x789);
    Purchase purchase;

    function setUp() public {
        vm.deal(alice, 1000);
        vm.deal(bob, 1000);

        vm.startPrank(alice);
        purchase = new Purchase{value: 500}();
        vm.stopPrank();
    }

    function test_abort_FailWhenSenderIsNotSeller() public {
        vm.startPrank(bob);
    
        vm.expectRevert(Purchase.OnlySeller.selector);
        purchase.abort();
    
        vm.stopPrank();
    }

    function test_abort_SuccessfulAbort() public {
        vm.startPrank(alice);
    
        purchase.abort();
    
    //    assertEq(uint(purchase.state()), uint(Purchase.State.Inactive));
    //    assertEq(alice.balance, 1500);
    //    assertEq(address(purchase).balance, 0);
    
        vm.stopPrank();
    }
    

    function test_abort_FailWhenStateIsNotCreated() public {
        vm.startPrank(alice);
    
        purchase.confirmPurchase{value: 500}();
    
        vm.expectRevert(Purchase.InvalidState.selector);
        purchase.abort();
    
        vm.stopPrank();
    }

    function test_confirmPurchase_FailWhenStateIsNotCreated() public {
        vm.startPrank(bob);
    
        purchase.confirmPurchase{value: 500}();
    
        vm.expectRevert(Purchase.InvalidState.selector);
        purchase.confirmPurchase{value: 500}();
    
        vm.stopPrank();
    }

    function test_confirmPurchase_SuccessfulPurchase() public {
        vm.startPrank(bob);
    
        purchase.confirmPurchase{value: 500}();
    
    //    assertEq(uint(purchase.state()), uint(Purchase.State.Locked));
    //    assertEq(purchase.buyer(), bob);
    //    assertEq(bob.balance, 500);
    //    assertEq(alice.balance, 1000);
    
        vm.stopPrank();
    }
    

    function test_confirmReceived_FailWhenSenderIsNotBuyer() public {
        vm.startPrank(bob);
    
        vm.expectRevert(Purchase.OnlyBuyer.selector);
        purchase.confirmReceived();
    
        vm.stopPrank();
    }

    function test_confirmReceived_SuccessfulConfirmation() public {
        vm.startPrank(bob);
    
        purchase.confirmPurchase{value: 500}();
        purchase.confirmReceived();
    
    //    assertEq(uint(purchase.state()), uint(Purchase.State.Release));
    //    assertEq(bob.balance, 750);
    //    assertEq(alice.balance, 1250);
    //    assertEq(address(purchase).balance, 250);
    
        vm.stopPrank();
    }
    

    function test_refundSeller_FailRefundWhenSenderIsNotSeller() public {
        vm.startPrank(bob);
    
        vm.expectRevert(Purchase.OnlySeller.selector);
        purchase.refundSeller();
    
        vm.stopPrank();
    }

    function test_refundSeller_SuccessfulRefund() public {
        vm.startPrank(bob);
        purchase.confirmPurchase{value: 500}();
        vm.stopPrank();
    
        vm.startPrank(bob);
        purchase.confirmReceived();
        vm.stopPrank();
    
        vm.startPrank(alice);
        purchase.refundSeller();
        vm.stopPrank();
    
    //    assertEq(uint(purchase.state()), uint(Purchase.State.Inactive));
    //    assertEq(alice.balance, 750);
    //    assertEq(bob.balance, 1250);
    }
    

    function test_refundSeller_FailWhenStateIsNotRelease() public {
        vm.startPrank(alice);
    
        vm.expectRevert(Purchase.InvalidState.selector);
        purchase.refundSeller();
    
        vm.stopPrank();
    }
}