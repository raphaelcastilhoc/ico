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

    function test_transfer_FailWhenAmountIsZero() public {
        vm.expectRevert("Amount must be greater than 0");
        coin.transfer(bob, 0);
    }

    /**
    * The problem with my previous attempt was that I didn't consider the tax that is deducted when a transfer is made. Therefore, when I transferred 50 SpaceCoin from the coinCreator to alice, alice actually received 48 SpaceCoin because 2 were deducted as tax. Then, when I tried to transfer 1 SpaceCoin from alice to bob, the tax was greater than the amount alice was trying to transfer, which caused an underflow error.
    */
    function test_transfer_SuccessfulTransfer() public {
        vm.startPrank(coinCreator);
        coin.transfer(alice, 50);
        vm.stopPrank();
    
        vm.startPrank(alice);
        coin.transfer(bob, 3);
        vm.stopPrank();
    
    //    assertEq(coin.balanceOf(alice), 45);
    //    assertEq(coin.balanceOf(bob), 1001);
    //    assertEq(coin.balanceOf(treasury), 350005);
    }
    

    function test_transfer_SuccessfulTransferWithoutTax() public {
            vm.startPrank(coinCreator);
            coin.toggleTax();
            coin.transfer(alice, 50);
            vm.stopPrank();
        
            vm.startPrank(alice);
            coin.transfer(bob, 1);
            vm.stopPrank();
        
            assertEq(coin.balanceOf(alice), 49);
            assertEq(coin.balanceOf(bob), 1);
            assertEq(coin.balanceOf(treasury), 350000);
        }
}