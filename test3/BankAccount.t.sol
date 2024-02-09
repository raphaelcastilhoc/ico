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
* The problem with my previous attempt was that I didn't consider that the withdraw function uses the low level call function to transfer the amount to the msg.sender. This function forwards all available gas to the called contract. In this case, the called contract is the alice address, which is an externally owned account, so it doesn't consume more than 2300 gas. The remaining gas is returned to the caller, which causes the caller to have a remaining balance. This remaining balance is not subtracted from the balance of the bank account, which causes the balance of the bank account to be greater than expected. To fix this, I need to check the balance of the bank account and the alice address before and after the withdraw function is called, and then assert that the differences are as expected.
*/
function test_withdraw_SuccessfulWithdraw() public {
    vm.deal(alice, 1000 ether);

    vm.startPrank(alice);

    bankAccount.deposit{value: 10 ether}();
    uint256 initialBankAccountBalance = bankAccount.getBalance();
    uint256 initialAliceBalance = alice.balance;
    bankAccount.withdraw(1 ether);
    uint256 finalBankAccountBalance = bankAccount.getBalance();
    uint256 finalAliceBalance = alice.balance;

    vm.stopPrank();

    assertEq(finalBankAccountBalance, initialBankAccountBalance - 1 ether);
    assertEq(finalAliceBalance, initialAliceBalance + 1 ether);
}
}