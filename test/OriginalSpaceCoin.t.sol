//SPDX-License-Identifier: Unlicense
pragma solidity 0.8.19;

import "forge-std/Test.sol";
import "contracts/Ico.sol";
import "contracts/OriginalSpaceCoin.sol";
import "./OlympixUnitTest.sol";

contract OriginalSpaceCoinTest is OlympixUnitTest("OriginalSpaceCoin") {
    address alice = address(0x456);
    address bob = address(0x789);
    address treasury = address(0xabc);
    address coinCreator = address(0xff);
    OriginalSpaceCoin coin;

    function setUp() public {
        vm.deal(coinCreator, 1000);
        vm.deal(alice, 1000);
        vm.deal(bob, 1000);

        vm.startPrank(coinCreator);
        coin = new OriginalSpaceCoin(treasury, coinCreator);
        vm.stopPrank();
    }

    function test_transfer_SuccessfulTransferWithTax() public {
        vm.startPrank(coinCreator);
    
        coin.transfer(alice, 100);
    
        vm.stopPrank();
    
        assertEq(coin.balanceOf(alice), 98);
        assertEq(coin.balanceOf(treasury), 350000 + 2);
    }

    function test_transfer_SuccessfulTransferWithoutTax() public {
        vm.startPrank(coinCreator);
    
        coin.toggleTax();
        coin.transfer(alice, 100);
    
        vm.stopPrank();
    
        assertEq(coin.balanceOf(alice), 100);
        assertEq(coin.balanceOf(treasury), 350000);
    }

    function test_toggleTax_FailWhenSenderIsNotOwner() public {
        vm.expectRevert("Only owner can call this function");
        coin.toggleTax();
    }

    function test_toggleTax_SuccessfulToggleWhenSenderIsOwner() public {
        vm.startPrank(coinCreator);
    
        coin.toggleTax();
    
        vm.stopPrank();
    
        assert(!coin.taxEnabled());
    }
}