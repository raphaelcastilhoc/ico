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

    function test_transfer_SuccessfulTransfer() public {
        vm.prank(coinCreator);
        coin.transfer(alice, 50);
        assertEq(coin.balanceOf(alice), 50);
    }

    function test_transfer_FailWhenAmountIsGreaterThan100() public {
        vm.startPrank(coinCreator);
    
        uint amount = 101;
        vm.expectRevert();
        coin.transfer(alice, amount);
        
        vm.stopPrank();
    }

    function test_transfer_SuccessfulTransferWithAmountLessThan100() public {
            vm.prank(coinCreator);
            uint amount = 99;
            coin.transfer(alice, amount);
            assertEq(coin.balanceOf(alice), amount);
        }

    function test_transfer_SuccessfulTransferWithTaxDisabled() public {
        vm.prank(coinCreator);
        uint amount = 50;
        coin.transfer(alice, amount);
        assertEq(coin.balanceOf(alice), amount);
    }

    function test_toggleTax_SuccessfulToggleTax() public {
        vm.prank(coinCreator);
        coin.toggleTax();
        assertTrue(coin.taxEnabled());
    }
}