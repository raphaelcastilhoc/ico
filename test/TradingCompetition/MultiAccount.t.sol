// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../../contracts/TradingCompetition/Perpetual/MultiAccount.sol";

abstract contract OlympixUnitTest is Test {
    constructor(string memory targetName) {}
}

contract MultiAccountTest is OlympixUnitTest("MultiAccount") {
    MultiAccount multiAccount;

    function setUp() public {
        multiAccount = new MultiAccount();
    }

    function test_addAccount_SuccessfulAddAccount() public {
        vm.startPrank(address(0x1));
    
        multiAccount.addAccount("Account 1");
    
        vm.stopPrank();
    
        IMultiAccount.Account[] memory accounts = multiAccount.getAccounts(address(0x1), 0, 1);
        IMultiAccount.Account memory account = accounts[0];
    
        assertEq(account.name, "Account 1");
    }

    function test_depositForAccount_FailWhenSenderIsNotOwner() public {
        vm.startPrank(address(0x1));
    
        vm.expectRevert("MultiAccount: Sender isn't owner of account");
        multiAccount.depositForAccount(address(0x1), 100);
    
        vm.stopPrank();
    }

    function test_depositAndAllocateForAccount_FailWhenSenderIsNotOwner() public {
        vm.startPrank(address(0x2));
    
        vm.expectRevert("MultiAccount: Sender isn't owner of account");
        multiAccount.depositAndAllocateForAccount(address(0x1), 100);
    
        vm.stopPrank();
    }

    function test_withdrawFromAccount_FailWhenSenderIsNotOwner() public {
        vm.startPrank(address(0x2));
    
        vm.expectRevert("MultiAccount: Sender isn't owner of account");
        multiAccount.withdrawFromAccount(address(0x1), 1);
    
        vm.stopPrank();
    }

    function test_call_FailWhenSenderIsNotOwner() public {
        vm.startPrank(address(0x1));
    
        vm.expectRevert("MultiAccount: Sender isn't owner of account");
        multiAccount._call(address(0x1), new bytes[](0));
    
        vm.stopPrank();
    }

    function test_getAccountsLength_SuccessfulGetAccountsLength() public {
        vm.startPrank(address(0x1));
    
        multiAccount.addAccount("Account 1");
    
        vm.stopPrank();
    
        uint256 accountsLength = multiAccount.getAccountsLength(address(0x1));
    
        assertEq(accountsLength, 1);
    }

    function test_getAccounts_SuccessfulGetAccounts() public {
        vm.startPrank(address(0x1));
    
        multiAccount.addAccount("Account 1");
        multiAccount.addAccount("Account 2");
        multiAccount.addAccount("Account 3");
    
        vm.stopPrank();
    
        IMultiAccount.Account[] memory accounts = multiAccount.getAccounts(address(0x1), 0, 2);
    
        assertEq(accounts.length, 2);
        assertEq(accounts[0].name, "Account 1");
        assertEq(accounts[1].name, "Account 2");
    }
}