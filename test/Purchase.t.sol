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

    function test_abort_FailWhenStateIsNotCreated() public {
        vm.startPrank(alice);
    
        purchase.confirmPurchase{value: 500}();
    
        vm.expectRevert(Purchase.InvalidState.selector);
        purchase.abort();
    
        vm.stopPrank();
    }

    function test_confirmPurchase_FailWhenStateIsNotCreated() public {
        vm.startPrank(alice);
    
        purchase.abort();
    
        vm.stopPrank();
    
        vm.startPrank(bob);
    
        vm.expectRevert(Purchase.InvalidState.selector);
        purchase.confirmPurchase{value: 500}();
    
        vm.stopPrank();
    }

    function test_confirmPurchase_SuccessfulConfirmPurchase() public {
        vm.startPrank(bob);
    
        purchase.confirmPurchase{value: 500}();
    
        vm.stopPrank();
    
        assertEq(bob.balance, 500);
        assertEq(purchase.buyer(), bob);
        assert(purchase.state() == Purchase.State.Locked);
    }

    function test_confirmPurchase_FailWhenValueIsNotCorrect() public {
        vm.startPrank(bob);
    
        vm.expectRevert();
        purchase.confirmPurchase{value: 400}();
    
        vm.stopPrank();
    }

    function test_confirmReceived_FailWhenSenderIsNotBuyer() public {
        vm.startPrank(bob);
    
        purchase.confirmPurchase{value: 500}();
    
        vm.stopPrank();
    
        vm.startPrank(alice);
    
        vm.expectRevert(Purchase.OnlyBuyer.selector);
        purchase.confirmReceived();
    
        vm.stopPrank();
    }

    function test_refundSeller_FailWhenSenderIsNotSeller() public {
        vm.startPrank(bob);
    
        purchase.confirmPurchase{value: 500}();
        purchase.confirmReceived();
    
        vm.expectRevert(Purchase.OnlySeller.selector);
        purchase.refundSeller();
    
        vm.stopPrank();
    }

    function test_refundSeller_SuccessfulRefundSeller() public {
        vm.startPrank(bob);
    
        purchase.confirmPurchase{value: 500}();
        purchase.confirmReceived();
    
        vm.stopPrank();
    
        vm.startPrank(alice);
    
        purchase.refundSeller();
    
        vm.stopPrank();
    
    //    assertEq(alice.balance, 1000);
    //    assertEq(bob.balance, 750);
    //    assert(purchase.state() == Purchase.State.Inactive);
    }
    

    function test_refundSeller_FailWhenStateIsNotRelease() public {
        vm.startPrank(alice);
    
        vm.expectRevert(Purchase.InvalidState.selector);
        purchase.refundSeller();
    
        vm.stopPrank();
    }
}