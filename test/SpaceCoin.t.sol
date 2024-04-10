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

    // function test_transfer_SuccessWhenTaxIsEnabled() public {
    //     vm.startPrank(coinCreator);
    //     coin.toggleTax();

    //     uint initialSenderBalance = coin.balanceOf(coinCreator);
    //     uint initialRecipientBalance = coin.balanceOf(treasury);

    //     uint amount = 99;
    //     coin.transfer(treasury, amount);

    //     uint tax = 2;
    //     uint amountAfterTax = amount - tax;
    //     assertEq(coin.balanceOf(coinCreator), initialSenderBalance - amount);
    //     assertEq(coin.balanceOf(treasury), initialRecipientBalance + amountAfterTax + tax);

    //     vm.stopPrank();
    // }

    function test_transfer_FailWhenAmountIsZero() public {
        vm.startPrank(coinCreator);
    
        uint256 amount = 0;
        vm.expectRevert("Amount must be greater than 0");
        coin.transfer(treasury, amount);
    
        vm.stopPrank();
    }

    function test_transfer_SuccessfulTransferWhenAmountIsGreaterThanZero() public {
        vm.startPrank(coinCreator);
    
        uint256 amount = 3;
        coin.transfer(treasury, amount);
    
        vm.stopPrank();
    }

    function test_transfer_FailWhenAmountIsGreaterThan100() public {
        vm.startPrank(coinCreator);
    
        uint256 amount = 101;
        vm.expectRevert("Amount is too high");
        coin.transfer(treasury, amount);
    
        vm.stopPrank();
    }

    function test_transfer_SuccessfulTransferWhenTaxIsDisabled() public {
            vm.startPrank(coinCreator);
            coin.toggleTax();
    
            uint initialSenderBalance = coin.balanceOf(coinCreator);
            uint initialRecipientBalance = coin.balanceOf(treasury);
    
            uint amount = 99;
            coin.transfer(treasury, amount);
    
            assertEq(coin.balanceOf(coinCreator), initialSenderBalance - amount);
            assertEq(coin.balanceOf(treasury), initialRecipientBalance + amount);
    
            vm.stopPrank();
        }

    function test_toggleTax_SuccessfulToggleWhenSenderIsOwner() public {
        vm.startPrank(coinCreator);
    
        bool initialTaxStatus = coin.taxEnabled();
        coin.toggleTax();
        bool finalTaxStatus = coin.taxEnabled();
    
        assert(finalTaxStatus != initialTaxStatus);
        
        vm.stopPrank();
    }
}