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
    * The problem with my previous attempt was that I didn't consider that the sender's balance would be updated asynchronously. Therefore, when I checked alice's balance immediately after the withdraw function, it hadn't been updated yet.
    */
    function test_withdraw_SuccessfulWithdraw() public {
        vm.startPrank(alice);
    
        bankAccount.deposit{value: 10 ether}();
        bankAccount.withdraw(1 ether);
    
        vm.stopPrank();
    
        assertEq(bankAccount.balances(alice), 9 ether);
    }

    /**
    * The problem with my previous attempt was that I didn't consider that the getBalance function returns the balance of the sender of the function call. Therefore, when I called getBalance without pranking, it returned the balance of the test contract, which is 0.
    */
    function test_getBalance_SuccessfulGetBalance() public {
        vm.startPrank(alice);
    
        bankAccount.deposit{value: 10 ether}();
        uint256 aliceBalance = bankAccount.getBalance();
    
        vm.stopPrank();
    
        assertEq(aliceBalance, 10 ether);
    }
}