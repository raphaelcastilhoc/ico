//SPDX-License-Identifier: Unlicense
pragma solidity 0.8.19;

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

    function test_confirmPurchase_FailWhenValueIsNotCorrect() public {
        vm.startPrank(bob);
    
        vm.expectRevert();
        purchase.confirmPurchase{value: 100}();
    
        vm.stopPrank();
    }

    function test_confirmPurchase_SuccessfulPurchaseConfirmation() public {
        vm.startPrank(bob);
    
        purchase.confirmPurchase{value: 500}();
    
        assertEq(purchase.buyer(), bob);
        assertEq(uint(purchase.state()), uint(Purchase.State.Locked));
    
        vm.stopPrank();
    }

    function test_confirmReceived_FailWhenSenderIsNotBuyer() public {
        vm.startPrank(bob);
    
        vm.expectRevert(Purchase.OnlyBuyer.selector);
        purchase.confirmReceived();
    
        vm.stopPrank();
    }

    function test_refundSeller_FailWhenSenderIsNotSeller() public {
        vm.startPrank(bob);
    
        vm.expectRevert(Purchase.OnlySeller.selector);
        purchase.refundSeller();
    
        vm.stopPrank();
    }

    function test_refundSeller_FailWhenStateIsNotRelease() public {
        vm.startPrank(alice);
    
        vm.expectRevert(Purchase.InvalidState.selector);
        purchase.refundSeller();
    
        vm.stopPrank();
    }
}