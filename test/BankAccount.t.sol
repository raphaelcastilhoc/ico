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
}
