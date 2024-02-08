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
* The problem with my previous attempt was that I didn't stop the prank before calling getBalance. As a result, the getBalance operation was called with the test contract as the sender, not alice. To fix this, I need to stop the prank before calling getBalance.
*/
function test_withdraw_SuccessfulWithdraw() public {
    vm.deal(alice, 10000 ether);
    vm.startPrank(alice);

    bankAccount.deposit{value: 10 ether}();
    bankAccount.withdraw(1 ether);

    vm.stopPrank();

    vm.startPrank(alice);
    uint256 aliceBankAccountBalance = bankAccount.getBalance();
    vm.stopPrank();

    assertEq(aliceBankAccountBalance, 9 ether);
    assertEq(alice.balance, 9991 ether);
}
}