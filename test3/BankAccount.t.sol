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
        vm.deal(alice, 1000);
        vm.deal(bob, 1000);
        vm.deal(david, 1000);

        bankAccount = new BankAccount();
    }

    /**
* The problem with my previous attempt was that I didn't provide enough balance to the alice address. The vm was out of funds to complete the transaction.
*/
function test_deposit_SuccessfulDeposit() public {
    vm.deal(alice, 10 ether);
    vm.startPrank(alice);

    bankAccount.deposit{value: 10 ether}();

    assertEq(bankAccount.balances(alice), 10 ether);
    vm.stopPrank();
}

    /**
* The problem with my previous attempt was that I didn't provide enough ether to the alice address. The vm was out of funds to complete the transaction.
*/
function test_getBalance_SuccessfulGetBalance() public {
    vm.deal(alice, 10 ether);
    
    vm.startPrank(alice);

    bankAccount.deposit{value: 10 ether}();
    uint256 aliceBalance = bankAccount.getBalance();
    vm.stopPrank();

    assertEq(aliceBalance, 10 ether);
}
}