// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.19;

import "forge-std/Test.sol";
import "contracts/BankAccount.sol";
import "./OlympixUnitTest.sol";

contract BankAccountTest is OlympixUnitTest("BankAccount") {
    address alice = address(0x3);
    address bob = address(0x4);
    address david = address(0x5);

    BankAccount bankAccount;

    function setUp() public {
        vm.deal(alice, 1000 ether);
        vm.deal(bob, 1000 ether);
        vm.deal(david, 1000 ether);

        bankAccount = new BankAccount();
    }

    /**
    * The problem with my previous attempts was that I was not calling getBalance() with the correct address. I was not pranking the vm when calling getBalance(), so it was returning the balance of this contract, not bob's balance.
    */
    function test_withdraw_SuccessfulWithdraw() public {
        vm.startPrank(bob);
    
        bankAccount.deposit{value: 10 ether}();
        bankAccount.withdraw(1 ether);
    
        uint256 bobBankAccountBalance = bankAccount.getBalance();
        vm.stopPrank();
    
        assertEq(bobBankAccountBalance, 9 ether);
        assertEq(bob.balance, 991 ether);
    }
}