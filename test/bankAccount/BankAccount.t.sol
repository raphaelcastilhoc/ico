// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../OlympixUnitTest.sol";
import "src/bankAccount/BankAccount.sol";

contract BankAccountTest is OlympixUnitTest("BankAccount") {
    address owner = address(0x456);
    address kate = address(0x789);
    address jack = address(0xabc);

    BankAccount bankAccount;

    function setUp() public {
        vm.prank(owner);
        bankAccount = new BankAccount();

        vm.deal(address(bankAccount), 1000);
        vm.deal(kate, 1000);
        vm.deal(jack, 1000);
    }

    

    function test_deposit_SuccessfulDepositWithBonus() public {
        vm.prank(owner);
        bankAccount.toggleBonusAdding(true);
        vm.startPrank(kate);
        bankAccount.deposit{value: 100}();
        vm.stopPrank();
        vm.prank(owner);
        uint256 kateBalance = bankAccount.getBalanceOf(kate);
        assertEq(kateBalance, 110);
    }

    function test_deposit_SuccessfulDepositWithoutBonus() public {
            vm.startPrank(kate);
            bankAccount.deposit{value: 100}();
            vm.stopPrank();
            vm.prank(owner);
            uint256 kateBalance = bankAccount.getBalanceOf(kate);
            assertEq(kateBalance, 100);
        }

    function test_withdraw_FailWhenAmountIsZero() public {
        vm.prank(kate);
        vm.expectRevert("Amount must be greater than 0");
        bankAccount.withdraw(0);
    }

    function test_withdraw_SuccessfulWithdraw() public {
        vm.startPrank(kate);
        bankAccount.deposit{value: 500}();
        bankAccount.withdraw(100);
        vm.stopPrank();
        vm.prank(owner);
        uint256 kateBalance = bankAccount.getBalanceOf(kate);
        assertEq(kateBalance, 400);
    }

    function test_withdraw_FailWhenBalanceIsLessThanAmount() public {
            vm.prank(kate);
            vm.expectRevert("Insufficient balance");
            bankAccount.withdraw(500);
        }

    function test_getBalance_SuccessfulGetBalance() public {
            vm.startPrank(kate);
            bankAccount.deposit{value: 500}();
            uint256 balance = bankAccount.getBalance();
            vm.stopPrank();
            assertEq(balance, 500);
        }

    function test_transfer_FailWhenAmountIsZero() public {
        vm.prank(kate);
        vm.deal(kate, 10 ether);
        bankAccount.deposit{value: 10 ether}();
    
        vm.expectRevert("Amount must be greater than 0");
        bankAccount.transfer(jack, 0);
    }

    function test_transfer_FailWhenSenderBalanceIsLessThanAmount() public {
            vm.prank(kate);
            vm.deal(kate, 10 ether);
            bankAccount.deposit{value: 10 ether}();
        
            vm.expectRevert("Insufficient balance");
            bankAccount.transfer(jack, 20 ether);
        }

    function test_transfer_SuccessfulTransfer() public {
            vm.startPrank(kate);
            bankAccount.deposit{value: 500}();
            bankAccount.transfer(jack, 100);
            vm.stopPrank();
            vm.prank(owner);
            uint256 kateBalance = bankAccount.getBalanceOf(kate);
            vm.prank(owner);
            uint256 jackBalance = bankAccount.getBalanceOf(jack);
            assertEq(kateBalance, 400);
            assertEq(jackBalance, 100);
        }

    function test_transfer_FailWhenSenderIsRecipient() public {
            vm.startPrank(kate);
            bankAccount.deposit{value: 500}();
            vm.expectRevert("Sender and recipient must be different");
            bankAccount.transfer(kate, 100);
            vm.stopPrank();
        }

    function test_getBalanceOf_FailWhenSenderIsNotOwner() public {
        vm.prank(kate);
        vm.expectRevert("Sender must be owner");
        bankAccount.getBalanceOf(jack);
    }

    function test_transferFrom_FailWhenSenderIsNotOwner() public {
        vm.expectRevert("Sender must be owner");
        bankAccount.transferFrom(kate, jack, 500);
    }

    function test_transferFrom_FailWhenAmountIsZero() public {
            vm.prank(owner);
            vm.expectRevert("Amount must be greater than 0");
            bankAccount.transferFrom(kate, jack, 0);
        }

    function test_transferFrom_FailWhenSenderBalanceIsLessThanAmount() public {
            vm.prank(owner);
            vm.expectRevert("Insufficient balance");
            bankAccount.transferFrom(kate, jack, 500);
        }

    function test_transferFrom_SuccessfulTransferFrom() public {
            vm.startPrank(kate);
            bankAccount.deposit{value: 500}();
            vm.stopPrank();
            vm.prank(owner);
            bankAccount.transferFrom(kate, jack, 100);
            vm.prank(owner);
            uint256 kateBalance = bankAccount.getBalanceOf(kate);
            vm.prank(owner);
            uint256 jackBalance = bankAccount.getBalanceOf(jack);
            assertEq(kateBalance, 400);
            assertEq(jackBalance, 100);
        }

    function test_transferFrom_FailWhenSenderAndRecipientAreTheSame() public {
            vm.startPrank(kate);
            bankAccount.deposit{value: 500}();
            vm.stopPrank();
            vm.prank(owner);
            vm.expectRevert("Sender and recipient must be different");
            bankAccount.transferFrom(kate, kate, 100);
        }

    function test_toggleBonusAdding_FailWhenSenderIsNotOwner() public {
        vm.prank(kate);
    
        vm.expectRevert("Sender must be owner");
        bankAccount.toggleBonusAdding(false);
    }

    function test_toggleBonusAdding_SuccessfulToggleBonusAdding() public {
        vm.prank(owner);
        bankAccount.toggleBonusAdding(true);
        bool result = bankAccount.shouldAddBonus();
        assertTrue(result);
    }
}