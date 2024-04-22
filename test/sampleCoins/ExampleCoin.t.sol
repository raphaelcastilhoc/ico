// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../OlympixUnitTest.sol";
import "src/sampleCoins/ExampleCoin.sol";

contract ExampleCoinTest is OlympixUnitTest("ExampleCoin") {
    address treasury = address(0x123);
    address owner = address(0x456);
    address elliot = address(0x789);
    address darlene = address(0xabc);

    ExampleCoin exampleCoin;

    function setUp() public {
        vm.prank(owner);
        exampleCoin = new ExampleCoin(treasury);

        deal(address(exampleCoin), elliot, 1000);
        deal(address(exampleCoin), darlene, 1000);
    }

    function test_transfer_FailWhenAmountIsZero() public {
        vm.startPrank(elliot);
    
        vm.expectRevert("Amount must be greater than 0");
        exampleCoin.transfer(darlene, 0);
    
        vm.stopPrank();
    }

    function test_transfer_SuccessfulTransferWhenAmountIsGreaterThanZero() public {
        vm.startPrank(elliot);
    
        exampleCoin.transfer(darlene, 500);
    
        uint256 elliotBalance = exampleCoin.balanceOf(elliot);
        uint256 darleneBalance = exampleCoin.balanceOf(darlene);
        assertEq(elliotBalance, 500);
        assertEq(darleneBalance, 1500);
    
        vm.stopPrank();
    }

    function test_transfer_FailWhenSenderAndRecipientAreSame() public {
        vm.startPrank(elliot);
    
        vm.expectRevert("Sender and recipient must be different");
        exampleCoin.transfer(elliot, 500);
    
        vm.stopPrank();
    }

    function test_transfer_FailWhenRecipientIsTreasury() public {
        vm.startPrank(elliot);
    
        vm.expectRevert("Recipient cannot be treasury");
        exampleCoin.transfer(treasury, 500);
    
        vm.stopPrank();
    }

    function test_transfer_SuccessfulTransferWhenShouldTaxIsTrue() public {
            vm.startPrank(owner);
            exampleCoin.toggleTax(true);
            vm.stopPrank();
    
            vm.startPrank(elliot);
            exampleCoin.transfer(darlene, 500);
            vm.stopPrank();
    
            uint256 elliotBalance = exampleCoin.balanceOf(elliot);
            uint256 darleneBalance = exampleCoin.balanceOf(darlene);
            uint256 treasuryBalance = exampleCoin.balanceOf(treasury);
            assertEq(elliotBalance, 490);
            assertEq(darleneBalance, 1500);
            assertEq(treasuryBalance, 100010);
        }

    function test_toggleTax_FailWhenSenderIsNotOwner() public {
        vm.startPrank(elliot);
        vm.expectRevert("Sender must be owner");
        exampleCoin.toggleTax(false);
        vm.stopPrank();
    }

    function test_toggleTax_SuccessfulToggleWhenSenderIsOwner() public {
        vm.startPrank(owner);
        exampleCoin.toggleTax(true);
        vm.stopPrank();
    }
}