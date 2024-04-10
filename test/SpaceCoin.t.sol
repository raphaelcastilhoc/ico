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

    function test_transfer_FailWhenAmountIsGreaterThan100() public {
        vm.startPrank(coinCreator);
    
        uint amount = 101;
        vm.expectRevert("Amount is too high");
        coin.transfer(alice, amount);
    
        vm.stopPrank();
    }

    function test_transfer_SuccessfulTransferWhenAmountIsLessThan100() public {
        vm.startPrank(coinCreator);
    
        uint amount = 99;
        coin.transfer(alice, amount);
    
        vm.stopPrank();
        
        assertEq(coin.balanceOf(alice), amount - 2);
        assertEq(coin.balanceOf(treasury), 350000 + 2);
    }

    function test_transfer_SuccessfulTransferWhenAmountIsLessThan100AndTaxIsDisabled() public {
            vm.startPrank(coinCreator);
        
            coin.toggleTax();
            uint amount = 99;
            coin.transfer(alice, amount);
        
            vm.stopPrank();
            
            assertEq(coin.balanceOf(alice), amount);
            assertEq(coin.balanceOf(treasury), 350000);
        }

    function test_toggleTax_FailWhenSenderIsNotOwner() public {
        vm.expectRevert("Only owner can call this function");
        coin.toggleTax();
    }

    function test_toggleTax_SuccessfulToggleWhenSenderIsOwner() public {
        vm.startPrank(coinCreator);
    
        bool initialTaxStatus = coin.taxEnabled();
        coin.toggleTax();
        bool finalTaxStatus = coin.taxEnabled();
    
        vm.stopPrank();
    
        assert(initialTaxStatus != finalTaxStatus);
    }
}