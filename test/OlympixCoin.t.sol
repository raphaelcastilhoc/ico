//SPDX-License-Identifier: Unlicense
pragma solidity 0.8.19;

import "forge-std/Test.sol";
import "contracts/OlympixCoin.sol";
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

    function test_transfer_SuccessfulTransfer() public {
        vm.startPrank(bob);
    
        coin.transfer(alice, 70);
    
        assertEq(coin.balanceOf(bob), 930);
        assertEq(coin.balanceOf(alice), 1068);
        assertEq(coin.balanceOf(treasury), 350002);
    
        vm.stopPrank();
    }
}
