// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.19;

import "forge-std/Test.sol";
// import "contracts/BankAccount.sol";
import "contracts/ChangedBankAccount.sol";

contract BankAccountTest is Test {
    address alice = address(0x3);
    address bob = address(0x4);
    address david = address(0x5);

    // BankAccount bankAccount;
    ChangedBankAccount bankAccount;

    function setUp() public {
        // bankAccount = new BankAccount();
        bankAccount = new ChangedBankAccount();
    }

    // function test_BankAccount_withdraw_EnoughBalance() public {
    //     vm.deal(alice, 1000);
    //     vm.startPrank(alice);
    //     bankAccount.deposit{value: 500}();
    //     bankAccount.withdraw(200);
    //     assertEq(bankAccount.getBalance(), 300, "Balance should be 300 after withdrawing 200");
    //     vm.stopPrank();
    // }

    // function test_BankAccount_withdraw_NotEnoughBalance() public {
    //     vm.deal(bob, 1000);
    //     vm.startPrank(bob);
    //     bankAccount.deposit{value: 100}();
    //     bankAccount.withdraw(200);
    //     assertEq(bankAccount.getBalance(), 100, "Balance should remain 100 after attempting to withdraw 200");
    //     vm.stopPrank();
    // }

    // function test_BankAccount_withdraw_FailToSend() public {
    //     vm.deal(david, 1000);
    //     vm.startPrank(david);
    //     bankAccount.deposit{value: 500}();
    //     vm.expectRevert();
    //     bankAccount.withdraw(200);
    //     // assertEq(bankAccount.getBalance(), 500, "Balance should remain 500 after failing to send");
    //     vm.stopPrank();
    // }
}