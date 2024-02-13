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
    vm.startPrank(bob);

    bankAccount.deposit{value: 1 ether}();
    bankAccount.withdraw(100);

    vm.stopPrank();
    
    assert(bob.balance == 1000 ether - 1 ether + 100);
    assert(bankAccount.balances(bob) == 1 ether - 100);
}

    /**
* The problem with my previous attempt was that I didn't start a prank before calling the getBalance function. Therefore, the msg.sender was the test contract itself and not the bob address. 
*/
function test_getBalance_SuccessfulGetBalance() public {
    vm.startPrank(bob);

    bankAccount.deposit{value: 1 ether}();
    
    uint256 bobBalance = bankAccount.getBalance();

    vm.stopPrank();
    
    assert(bobBalance == 1 ether);
}
}