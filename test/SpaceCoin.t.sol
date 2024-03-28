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

    /**
    * The problem with my previous attempt was that I was trying to transfer 1000 coins to the ico contract as the coinCreator before starting a prank as alice and trying to transfer 101 coins to bob. However, the transfer function in the SpaceCoin contract has a condition that reverts the transaction if the amount is greater than 100. Therefore, the transfer of 1000 coins to the ico contract was failing and causing the test to fail. To fix this, I need to transfer a smaller amount of coins to the ico contract.
    */
    function test_transfer_FailWhenAmountIsGreaterThan100() public {
        vm.startPrank(coinCreator);
    
        address[] memory allowList = new address[](0);
        Ico ico = new Ico(allowList, treasury);
        coin.transfer(address(ico), 100);
    
        vm.stopPrank();
    
        vm.startPrank(alice);
    
        vm.expectRevert();
        coin.transfer(bob, 101);
        
        vm.stopPrank();
    }

    function test_toggleTax_SuccessfulToggleTax() public {
        vm.startPrank(coinCreator);
    
        coin.toggleTax();
    
        vm.stopPrank();
    
        bool taxEnabled = coin.taxEnabled();
        assertTrue(taxEnabled == false);
    }
}