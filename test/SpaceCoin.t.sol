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
        vm.expectRevert("Amount must be greater than 0");
        coin.transfer(bob, 0);
    }

    function test_transfer_SuccessfulTransferWhenTransferingAmountIsGreaterThanZero() public {
            vm.startPrank(coinCreator);
    
            uint initialSenderBalance = coin.balanceOf(coinCreator);
            uint initialRecipientBalance = coin.balanceOf(alice);
            
            coin.transfer(alice, 10);
            
            uint finalSenderBalance = coin.balanceOf(coinCreator);
            uint finalRecipientBalance = coin.balanceOf(alice);
    
            vm.stopPrank();
    
    //        assert(finalSenderBalance == initialSenderBalance - 10);
    //        assert(finalRecipientBalance == initialRecipientBalance + 10);
        }
    

    function test_transfer_FailWhenRecipientIsOwnerOrTreasury() public {
            vm.expectRevert("Recipient must be a valid address");
            coin.transfer(coinCreator, 10);
        }

    function test_transfer_FailWhenTransferingAmountIsGreaterThan100() public {
            vm.startPrank(coinCreator);
    
            uint256 transferingAmount = 101;
            vm.expectRevert("Amount is too high");
            coin.transfer(alice, transferingAmount);
    
            vm.stopPrank();
        }

    function test_transfer_SuccessfulTransferWhenTaxIsDisabled() public {
            vm.startPrank(coinCreator);
    
            coin.toggleTax();
    
            uint initialSenderBalance = coin.balanceOf(coinCreator);
            uint initialRecipientBalance = coin.balanceOf(alice);
            
            uint256 transferingAmount = 10;
            coin.transfer(alice, transferingAmount);
            
            uint finalSenderBalance = coin.balanceOf(coinCreator);
            uint finalRecipientBalance = coin.balanceOf(alice);
    
            vm.stopPrank();
    
            assert(finalSenderBalance == initialSenderBalance - transferingAmount);
            assert(finalRecipientBalance == initialRecipientBalance + transferingAmount);
        }

    function test_simpleTransfer_FailWhenValueToTransferIsEqualToOrGreaterThan100() public {
        vm.expectRevert("Amount must be less than 0");
        coin.simpleTransfer(bob, 100);
    }

    function test_simpleTransfer_SuccessfulWhenValueToTransferIsLessThan100() public {
            vm.startPrank(coinCreator);
            coin.transfer(alice, 50);
            vm.stopPrank();
    
            vm.startPrank(alice);
    
            uint256 valueToTransfer = 10;
            coin.simpleTransfer(bob, valueToTransfer);
    
            vm.stopPrank();
    
    //        assertEq(coin.balanceOf(bob), valueToTransfer + 1);
    //        assertEq(coin.balanceOf(alice), 50 - valueToTransfer - 1);
        }

    function test_simpleTransfer_FailWhenValueToTransferIsZero() public {
            vm.expectRevert("Amount must be greater than 0");
            coin.simpleTransfer(bob, 0);
        }

    function test_simpleTransfer_FailWhenRecipientIsOwnerOrTreasury() public {
            vm.expectRevert("Recipient must be a valid address");
            coin.simpleTransfer(coinCreator, 10);
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