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
* The problem with my previous attempt was that I didn't stop the prank before calling the getBalance function. As a result, the getBalance function was called with alice as the sender, and since alice's balance in the contract was 0, the function returned 0. To fix this, I need to stop the prank before calling the getBalance function.
*/
function test_withdraw_SuccessfulWithdraw() public {
    vm.deal(alice, 100 ether);
    
    vm.startPrank(alice);

    bankAccount.deposit{value: 10 ether}();
    bankAccount.withdraw(1 ether);

    vm.stopPrank();

    assertEq(bankAccount.balances(alice), 9 ether);
    assertEq(alice.balance, 91 ether);
}

    /**
* The problem with my previous attempt was that I was passing an argument to the getBalance function, which doesn't take any arguments. The getBalance function uses msg.sender to determine the balance to return, so I need to use vm.startPrank and vm.stopPrank to set the sender to alice before and after calling the function.
*/
function test_getBalance_SuccessfulGetBalance() public {
    vm.deal(alice, 100 ether);
    
    vm.startPrank(alice);

    bankAccount.deposit{value: 10 ether}();

    uint256 aliceBalance = bankAccount.getBalance();

    vm.stopPrank();

    assertEq(aliceBalance, 10 ether);
}
}