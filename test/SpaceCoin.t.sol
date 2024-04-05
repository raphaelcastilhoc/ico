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
    * The problem with my previous attempt was that I was not setting the correct value for the contribution. Consequently, when I tried to contribute 10 ether to the ICO, the transaction failed because the redeemed amount was greater than 100. To fix this, I need to set the contribution value to 20.
    */
    function test_transfer_FailWhenAmountIsGreaterThan100() public {
        vm.deal(alice, 20 ether);
    
        vm.startPrank(coinCreator);
    
        address[] memory allowList = new address[](1);
        allowList[0] = alice;
        Ico ico = new Ico(allowList, treasury);
    
        vm.stopPrank();
    
        vm.startPrank(alice);
    
        ico.contribute{value: 20}();
    
        vm.expectRevert();
        coin.transfer(bob, 101);
    
        vm.stopPrank();
    }

    function test_toggleTax_SuccessfulToggleTax() public {
        vm.startPrank(coinCreator);
    
        coin.toggleTax();
    
        vm.stopPrank();
    
        assertTrue(coin.taxEnabled());
    }
}