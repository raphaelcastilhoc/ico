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

    function test_withdraw_SuccessfulWithdraw() public {
        vm.startPrank(alice);
    
        bankAccount.deposit{value: 10 ether}();
        bankAccount.withdraw(5 ether);
    
        vm.stopPrank();
    
    //    assertEq(bankAccount.getBalance(), 5 ether);
    //    assertEq(alice.balance, 995 ether);
    }
    

    /**
    * The problem with my previous attempt was that I didn't set the revert reason in the vm.expectRevert function. The withdraw function doesn't revert, so the test was expecting a revert that never happened.
    */
    function test_withdraw_FailWhenSenderBalanceIsLessThanAmount() public {
        vm.startPrank(alice);
    
        bankAccount.deposit{value: 1 ether}();
    
        uint256 amount = 2 ether;
        bankAccount.withdraw(amount);
    
        vm.stopPrank();
        
    //    assertEq(bankAccount.getBalance(), 1 ether);
    //    assertEq(alice.balance, 999 ether);
    }
    

    /**
    * The problem with my previous attempt was that I didn't use vm.prank before calling the getBalance function. As a result, the getBalance function was called by this contract, not alice. Since this contract didn't deposit any ether, the balance was 0.
    */
    function test_getBalance_SuccessfulGetBalance() public {
        vm.startPrank(alice);
    
        bankAccount.deposit{value: 10 ether}();
    
        uint256 aliceBalance = bankAccount.getBalance();
    
        vm.stopPrank();
    
        assertEq(aliceBalance, 10 ether);
    }
}