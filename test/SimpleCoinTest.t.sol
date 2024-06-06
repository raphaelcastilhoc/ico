//SPDX-License-Identifier: Unlicense
pragma solidity 0.8.19;

import "forge-std/Test.sol";
import "contracts/SimpleCoin.sol";
import "./OlympixUnitTest.sol";

contract SimpleCoinTest is OlympixUnitTest("SimpleCoin") {
    address alice = address(0x456);
    address bob = address(0x789);
    address owner = address(0xff);
    SimpleCoin simpleCoin;

    function setUp() public {
        vm.startPrank(owner);
        simpleCoin = new SimpleCoin(owner);
        vm.stopPrank();

        deal(address(simpleCoin), alice, 1000);
        deal(address(simpleCoin), bob, 1000);
    }

    function test_transfer_FailWhenAmountIsInvalid() public {
        vm.startPrank(alice);
    
        vm.expectRevert("Amount must be greater than 0");
        simpleCoin.transfer(bob, 0, 1);
    
        vm.stopPrank();
    }

    function test_transfer_SuccessfulTransfer() public {
        vm.startPrank(alice);
    
        simpleCoin.transfer(bob, 100, 1);
    
        vm.stopPrank();
    
        assertEq(simpleCoin.balanceOf(alice), 901);
        assertEq(simpleCoin.balanceOf(bob), 1099);
    }

    function test_transfer_FailWhenMaxTaxIsInvalid() public {
        vm.startPrank(alice);
    
        vm.expectRevert("Max tax must be greater than 0");
        simpleCoin.transfer(bob, 100, 0);
    
        vm.stopPrank();
    }

    function test_transfer_FailWhenRecipientIsInvalid() public {
        vm.startPrank(alice);
    
        vm.expectRevert("Recipient must be different from owner");
        simpleCoin.transfer(owner, 100, 1);
    
        vm.stopPrank();
    }

    function test_transfer_FailWhenSenderIsInvalid() public {
        vm.startPrank(owner);
    
        vm.expectRevert("Sender must be different from owner");
        simpleCoin.transfer(alice, 100, 1);
    
        vm.stopPrank();
    }
}