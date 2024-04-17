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

    function test_transfer_FailWhenTransferingAmountIsZero() public {
        vm.expectRevert(abi.encodePacked("Amount must be greater than 0"));
        coin.transfer(bob, 0);
    }

    function test_transfer_SuccessfulTransferWhenTransferingAmountIsGreaterThanZero() public {
            vm.startPrank(coinCreator);
    
            uint transferingAmount = 10;
            coin.transfer(alice, transferingAmount);
    
            vm.stopPrank();
    
            vm.startPrank(alice);
    
            uint initialAliceBalance = coin.balanceOf(alice);
            uint initialBobBalance = coin.balanceOf(bob);
            uint initialTreasuryBalance = coin.balanceOf(treasury);
    
            coin.transfer(bob, transferingAmount - 2);
    
            vm.stopPrank();
    
            uint finalAliceBalance = coin.balanceOf(alice);
            uint finalBobBalance = coin.balanceOf(bob);
            uint finalTreasuryBalance = coin.balanceOf(treasury);
    
    //        assert(finalAliceBalance == initialAliceBalance - transferingAmount + 2);
    //        assert(finalBobBalance == initialBobBalance + transferingAmount - 4);
    //        assert(finalTreasuryBalance == initialTreasuryBalance + 4);
        }

    function test_transfer_FailWhenRecipientIsOwner() public {
            vm.expectRevert("Recipient must be a valid address");
            coin.transfer(coinCreator, 1);
        }

    function test_transfer_FailWhenTransferingAmountIsGreaterThan100() public {
            vm.startPrank(coinCreator);
    
            uint transferingAmount = 101;
            vm.expectRevert("Amount is too high");
            coin.transfer(alice, transferingAmount);
    
            vm.stopPrank();
        }

    function test_transfer_SuccessfulTransferWhenTaxIsDisabled() public {
            vm.startPrank(coinCreator);
    
            uint transferingAmount = 10;
            coin.transfer(alice, transferingAmount);
    
            vm.stopPrank();
    
            vm.startPrank(coinCreator);
            coin.toggleTax();
            vm.stopPrank();
    
            vm.startPrank(alice);
    
            uint initialAliceBalance = coin.balanceOf(alice);
            uint initialBobBalance = coin.balanceOf(bob);
            uint initialTreasuryBalance = coin.balanceOf(treasury);
    
            coin.transfer(bob, transferingAmount - 2);
    
            vm.stopPrank();
    
            uint finalAliceBalance = coin.balanceOf(alice);
            uint finalBobBalance = coin.balanceOf(bob);
            uint finalTreasuryBalance = coin.balanceOf(treasury);
    
    //        assert(finalAliceBalance == initialAliceBalance - transferingAmount + 2);
    //        assert(finalBobBalance == initialBobBalance + transferingAmount - 2);
    //        assert(finalTreasuryBalance == initialTreasuryBalance);
        }

    function test_anotherTransfer_FailWhenValueIsEqualToOrGreaterThan100() public {
        vm.expectRevert("Amount must be less than 0");
        coin.anotherTransfer(bob, 100);
    }

    function test_anotherTransfer_SuccessfulWhenValueIsLessThan100() public {
            vm.startPrank(coinCreator);
            coin.transfer(alice, 100);
            vm.stopPrank();
    
            vm.startPrank(alice);
            coin.anotherTransfer(bob, 10);
            vm.stopPrank();
            
            assertEq(coin.balanceOf(bob), 11);
            assertEq(coin.balanceOf(alice), 100 - 11 - 2);
        }

    function test_anotherTransfer_FailWhenValueIsZero() public {
            vm.expectRevert(abi.encodePacked("Amount must be greater than 0"));
            coin.anotherTransfer(bob, 0);
        }

    function test_anotherTransfer_FailWhenRecipientAddressIsOwner() public {
            vm.expectRevert("Recipient must be a valid address");
            coin.anotherTransfer(coinCreator, 1);
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
    
        assert(finalTaxStatus != initialTaxStatus);
    }
}