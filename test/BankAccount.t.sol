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
        bankAccount.withdraw(1 ether);
    
        vm.stopPrank();
    
    //    assertEq(bankAccount.getBalance(), 9 ether);
    //    assertEq(alice.balance, 991 ether);
    }
    

    function test_getBalance_SuccessfulGetBalance() public {
        vm.startPrank(alice);
    
        bankAccount.deposit{value: 10 ether}();
        uint256 aliceBalance = bankAccount.getBalance();
    
        vm.stopPrank();
    
        assertEq(aliceBalance, 10 ether);
    }
}