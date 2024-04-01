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
    * The problem with my previous attempt was that I was checking alice's balance using the getBalance function of the BankAccount contract instead of checking alice's ether balance. Therefore, when I checked alice's balance, it was still the initial balance because the withdraw function hadn't completed yet.
    */
    function test_withdraw_SuccessfulWithdraw() public {
        vm.startPrank(alice);
    
        bankAccount.deposit{value: 10 ether}();
        bankAccount.withdraw(5 ether);
    
        vm.stopPrank();
    
        vm.startPrank(alice);
        assertEq(bankAccount.getBalance(), 5 ether);
        vm.stopPrank();
        assertEq(alice.balance, 995 ether);
    }
}