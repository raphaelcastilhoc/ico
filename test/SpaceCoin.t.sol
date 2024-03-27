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

    function test_transfer_FailWhenAmountIsGreaterThan100() public {
        vm.startPrank(coinCreator);
    
        uint initialSenderBalance = coin.balanceOf(coinCreator);
        uint initialRecipientBalance = coin.balanceOf(treasury);
        
        uint amount = 101;
        vm.expectRevert();
        coin.transfer(treasury, amount);
    
        assertEq(coin.balanceOf(coinCreator), initialSenderBalance);
        assertEq(coin.balanceOf(treasury), initialRecipientBalance);
    
        vm.stopPrank();
    }

    /**
    * The problem with my previous attempt was that I didn't consider the tax that is deducted from the amount to be transferred. The tax is transferred to the treasury and the remaining amount is transferred to the recipient. Therefore, the recipient's balance should increase by amountAfterTax and not the full amount.
    */
    function test_transfer_SuccessfulTransferWhenAmountIsLessThan100() public {
        vm.startPrank(coinCreator);
    
        uint initialSenderBalance = coin.balanceOf(coinCreator);
        uint initialRecipientBalance = coin.balanceOf(treasury);
        
        uint amount = 99;
        coin.transfer(treasury, amount);
    
        uint tax = 2;
        uint amountAfterTax = amount - tax;
        assertEq(coin.balanceOf(coinCreator), initialSenderBalance - amount);
        assertEq(coin.balanceOf(treasury), initialRecipientBalance + amountAfterTax + tax);
    
        vm.stopPrank();
    }

    function test_transfer_SuccessfulTransferWhenTaxIsDisabled() public {
        vm.startPrank(coinCreator);
    
        coin.toggleTax();
    
        uint initialSenderBalance = coin.balanceOf(coinCreator);
        uint initialRecipientBalance = coin.balanceOf(treasury);
        
        uint amount = 99;
        coin.transfer(treasury, amount);
    
        assertEq(coin.balanceOf(coinCreator), initialSenderBalance - amount);
        assertEq(coin.balanceOf(treasury), initialRecipientBalance + amount);
    
        vm.stopPrank();
    }
}