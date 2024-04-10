//SPDX-License-Identifier: Unlicense
pragma solidity 0.8.19;

import "forge-std/Test.sol";
import "contracts/Ico.sol";
import "./OlympixUnitTest.sol";

contract SpaceCoinTest is OlympixUnitTest("SpaceCoin") {
    address alice = address(0x456);
    address bob = address(0x789);
    address treasury = address(0xabc);
    address coinCreator = address(0xff);
    SpaceCoin coin;

    function setUp() public {
        vm.deal(coinCreator, 1000);
        vm.deal(alice, 1000);
        vm.deal(bob, 1000);

        vm.startPrank(coinCreator);
        coin = new SpaceCoin(treasury, coinCreator);
        vm.stopPrank();
    }

    function test_transfer_FailWhenSenderIsNotOwner() public {
        vm.expectRevert("Only owner can call this function");
        coin.transfer(alice, 50);
    }

    function test_transfer_SuccessfulTransfer() public {
        vm.startPrank(coinCreator);
    
        uint initialSenderBalance = coin.balanceOf(coinCreator);
        uint initialRecipientBalance = coin.balanceOf(alice);
        uint initialTreasuryBalance = coin.balanceOf(treasury);
    
        uint amount = 50;
        uint tax = 2;
        uint amountAfterTax = amount - tax;
    
        coin.transfer(alice, amount);
    
        uint finalSenderBalance = coin.balanceOf(coinCreator);
        uint finalRecipientBalance = coin.balanceOf(alice);
        uint finalTreasuryBalance = coin.balanceOf(treasury);
    
        assertEq(finalSenderBalance, initialSenderBalance - amount, "Sender balance incorrect");
        assertEq(finalRecipientBalance, initialRecipientBalance + amountAfterTax, "Recipient balance incorrect");
        assertEq(finalTreasuryBalance, initialTreasuryBalance + tax, "Treasury balance incorrect");
    
        vm.stopPrank();
    }

    function test_transfer_FailWhenAmountIsGreaterThan100() public {
            vm.startPrank(coinCreator);
    
            uint amount = 101;
            vm.expectRevert("Amount is too high");
            coin.transfer(alice, amount);
    
            vm.stopPrank();
        }

    function test_transfer_SuccessfulTransferWhenTaxIsDisabled() public {
            vm.startPrank(coinCreator);
        
            coin.toggleTax();
        
            uint initialSenderBalance = coin.balanceOf(coinCreator);
            uint initialRecipientBalance = coin.balanceOf(alice);
        
            uint amount = 50;
        
            coin.transfer(alice, amount);
        
            uint finalSenderBalance = coin.balanceOf(coinCreator);
            uint finalRecipientBalance = coin.balanceOf(alice);
        
            assertEq(finalSenderBalance, initialSenderBalance - amount, "Sender balance incorrect");
            assertEq(finalRecipientBalance, initialRecipientBalance + amount, "Recipient balance incorrect");
        
            vm.stopPrank();
        }

    function test_toggleTax_FailWhenSenderIsNotOwner() public {
        vm.expectRevert("Only owner can call this function");
        coin.toggleTax();
    }

    function test_toggleTax_SuccessWhenSenderIsOwner() public {
        vm.startPrank(coinCreator);
    
        coin.toggleTax();
    
        vm.stopPrank();
        
        bool taxEnabled = coin.taxEnabled();
        assertTrue(taxEnabled == false);
    }
}