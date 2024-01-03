// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.19;

import "forge-std/Test.sol";
// import "contracts/BankAccount.sol";
import "contracts/ChangedBankAccount.sol";

contract BankAccountTest is Test {
    address alice = address(0x3);
    address bob = address(0x4);
    address david = address(0x5);

    // BankAccount bankAccount;
    ChangedBankAccount bankAccount;

    function setUp() public {
        // bankAccount = new BankAccount();
        bankAccount = new ChangedBankAccount();
    }
}