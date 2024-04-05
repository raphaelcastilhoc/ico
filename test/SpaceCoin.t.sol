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

    function test_transfer_SuccessfulTransferWhenTaxIsDisabled() public {
            vm.prank(coinCreator);
            coin.transfer(alice, 50);
            assertEq(coin.balanceOf(alice), 50);
        }

    function test_toggleTax_SuccessfulToggleTax() public {
        vm.prank(coinCreator);
        coin.toggleTax();
        assertTrue(coin.taxEnabled());
    }
}