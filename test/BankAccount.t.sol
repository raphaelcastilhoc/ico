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

    function test_deposit_SuccessfulDeposit() public {
        vm.startPrank(alice);
    
        bankAccount.deposit{value: 10 ether}();
    
        assert(bankAccount.getBalance() == 10 ether);
        
        vm.stopPrank();
    }

    function test_getBalance_SuccessfulGetBalance() public {
        vm.startPrank(alice);
    
        bankAccount.deposit{value: 10 ether}();
        uint256 balance = bankAccount.getBalance();
        vm.stopPrank();
    
        assertEq(balance, 10 ether);
    }
}