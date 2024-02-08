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
* The problem with my previous attempt was that I didn't call the deposit function with the prank of alice address. So, the balance was being added to the test contract address instead of alice address.
*/
function test_withdraw_SuccessfulWithdraw() public {
    vm.deal(alice, 2000 ether);

    vm.startPrank(alice);

    bankAccount.deposit{value: 10 ether}();
    bankAccount.withdraw(1 ether);

    vm.stopPrank();

    vm.startPrank(alice);

    assertEq(bankAccount.getBalance(), 9 ether);

    vm.stopPrank();

    assertEq(alice.balance, 1991 ether);
}
}