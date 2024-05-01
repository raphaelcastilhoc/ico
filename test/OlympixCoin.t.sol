//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "src/OlympixCoin.sol";
import "./OlympixUnitTest.sol";

contract OlympixCoinTest is OlympixUnitTest("OlympixCoin") {
    address alice = address(0x456);
    address bob = address(0x789);
    address treasury = address(0xabc);
    address coinCreator = address(0xff);
    OlympixCoin coin;

    function setUp() public {
        vm.deal(coinCreator, 1000);

        vm.startPrank(coinCreator);
        coin = new OlympixCoin(treasury, coinCreator);
        vm.stopPrank();

        deal(address(coin), alice, 1000);
        deal(address(coin), bob, 1000);
    }

    function test_transfer_SuccessfulTransferWithTax() public {
        vm.startPrank(alice);
    
        coin.transfer(bob, 100);
    
        assertEq(coin.balanceOf(alice), 900);
        assertEq(coin.balanceOf(bob), 1000 + 98);
        assertEq(coin.balanceOf(treasury), 350000 + 2);
    
        vm.stopPrank();
    }

    function test_transfer_SuccessfulTransferWithoutTax() public {
        vm.startPrank(coinCreator);
    
        coin.toggleTax();
    
        vm.stopPrank();
    
        vm.startPrank(alice);
    
        coin.transfer(bob, 100);
    
        assertEq(coin.balanceOf(alice), 900);
        assertEq(coin.balanceOf(bob), 1000 + 100);
        assertEq(coin.balanceOf(treasury), 350000);
    
        vm.stopPrank();
    }

    function test_toggleTax_FailWhenSenderIsNotOwner() public {
        vm.startPrank(alice);
    
        vm.expectRevert("Only owner can call this function");
        coin.toggleTax();
    
        vm.stopPrank();
    }

    function test_toggleTax_SuccessfulToggle() public {
        vm.startPrank(coinCreator);
    
        coin.toggleTax();
    
        assertEq(coin.taxEnabled(), false);
    
        vm.stopPrank();
    }
}