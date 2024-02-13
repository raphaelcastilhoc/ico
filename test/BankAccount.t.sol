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

    function test_deposit_SuccessfulDeposit() public {
    vm.deal(alice, 10 ether);
    vm.startPrank(alice);

    bankAccount.deposit{value: 10 ether}();

    uint256 balance = bankAccount.getBalance();
    vm.stopPrank();

    assertEq(balance, 10 ether);
}

    /**
* The problem with my previous attempt was that I didn't provide enough ether to the address I was pranking as. The address needs to have enough ether to be able to deposit into the bank account.
*/
function test_getBalance_SuccessfulGetBalance() public {
    vm.deal(alice, 10 ether);
    vm.startPrank(alice);

    bankAccount.deposit{value: 10 ether}();
    uint256 balance = bankAccount.getBalance();
    vm.stopPrank();

    assertEq(balance, 10 ether);
}
}