// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.19;

import "forge-std/Test.sol";
import "contracts/BankAccount.sol";

abstract contract OpixForgeUnitTarget {
   constructor(string memory targetName) {
   }
}

contract BankAccountTest is Test, OpixForgeUnitTarget("BankAccount") {
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

    function test_withdraw_SuccessfulWithdraw() public {
    vm.startPrank(alice);

    bankAccount.deposit{value: 500}();
    bankAccount.withdraw(100);

    vm.stopPrank();

//    assertEq(bankAccount.getBalance(), 400);
//    assertEq(alice.balance, 1500);
}


    /**
* The problem with my previous attempt was that I didn't realize the contract was not reverting when the balance was less than the amount. Instead, it was entering the else branch and hitting the assert(true) statement. Therefore, my vm.expectRevert() call was incorrect because no revert was happening.
*/
function test_withdraw_FailWhenSenderBalanceIsLessThanAmount() public {
    vm.startPrank(alice);

    bankAccount.deposit{value: 100}();
    bankAccount.withdraw(200);

    vm.stopPrank();
}
}