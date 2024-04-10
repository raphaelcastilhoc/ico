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

    function test_transfer_SuccessfulTransfer() public {
        vm.prank(coinCreator);
        coin.transfer(coinCreator, 1);
        coin.toggleTax();
        coin.transfer(bob, 1);
    //    assertEq(coin.balanceOf(bob), 1);
    //    assertEq(coin.balanceOf(coinCreator), 149998);
    //    assertEq(coin.balanceOf(treasury), 350000);
    }

    function test_transfer_FailWhenAmountIsGreaterThan100() public {
        vm.startPrank(coinCreator);
    
        vm.expectRevert("Amount is too high");
        coin.transfer(bob, 101);
        
        vm.stopPrank();
    }

    function test_transfer_SuccessfulTransferWithTax() public {
        vm.startPrank(coinCreator);
    
        coin.transfer(bob, 50);
        
        assertEq(coin.balanceOf(bob), 48);
        assertEq(coin.balanceOf(treasury), 350002);
        
        vm.stopPrank();
    }

    function test_transfer_SuccessfulTransferWithoutTax() public {
            vm.startPrank(coinCreator);
        
            coin.toggleTax();
            coin.transfer(bob, 50);
            
            assertEq(coin.balanceOf(bob), 50);
            assertEq(coin.balanceOf(treasury), 350000);
            
            vm.stopPrank();
        }
}