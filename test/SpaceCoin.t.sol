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

    

    function test_transfer_FailWhenAmountIsGreaterThanZero() public {
        vm.startPrank(coinCreator);
        vm.expectRevert("Amount must be greater than 0");
        coin.transfer(bob, 0);
        vm.stopPrank();
    }

    function test_transfer_SuccessfulTransferWhenAmountIsGreaterThanZero() public {
        vm.startPrank(coinCreator);
    
        uint initialBobBalance = coin.balanceOf(bob);
        uint initialCoinCreatorBalance = coin.balanceOf(coinCreator);
        uint initialTreasuryBalance = coin.balanceOf(treasury);
    
        uint amount = 3;
        uint tax = 2;
        uint amountAfterTax = amount - tax;
    
        coin.transfer(bob, amount);
    
        assertEq(coin.balanceOf(bob), initialBobBalance + amountAfterTax);
        assertEq(coin.balanceOf(coinCreator), initialCoinCreatorBalance - amount);
        assertEq(coin.balanceOf(treasury), initialTreasuryBalance + tax);
    
        vm.stopPrank();
    }

    function test_transfer_FailWhenAmountIsGreaterThanHundred() public {
            vm.startPrank(coinCreator);
            vm.expectRevert("Amount is too high");
            coin.transfer(bob, 101);
            vm.stopPrank();
        }

    function test_transfer_SuccessfulTransferWhenTaxIsDisabled() public {
            vm.startPrank(coinCreator);
            coin.toggleTax();
            uint initialBobBalance = coin.balanceOf(bob);
            uint initialCoinCreatorBalance = coin.balanceOf(coinCreator);
    
            uint amount = 3;
    
            coin.transfer(bob, amount);
    
            assertEq(coin.balanceOf(bob), initialBobBalance + amount);
            assertEq(coin.balanceOf(coinCreator), initialCoinCreatorBalance - amount);
    
            vm.stopPrank();
        }
}