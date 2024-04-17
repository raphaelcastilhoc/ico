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

    function test_transfer_FailWhenRecipientIsEqualToOwnerOrTreasury() public {
            vm.startPrank(coinCreator);
    
            vm.expectRevert(abi.encodePacked("Recipient must be a valid address"));
            coin.transfer(coinCreator, 1);
    
            vm.expectRevert(abi.encodePacked("Recipient must be a valid address"));
            coin.transfer(treasury, 1);
    
            vm.stopPrank();
        }

    function test_transfer_FailWhenTransferingAmountIsGreaterThan100() public {
            vm.startPrank(coinCreator);
    
            uint256 valueToTransfer = 101;
            vm.expectRevert("Amount is too high");
            coin.transfer(bob, valueToTransfer);
    
            vm.stopPrank();
        }

    function test_transfer_SuccessfulTransferWhenTaxIsDisabled() public {
            vm.startPrank(coinCreator);
    
            coin.toggleTax();
    
            uint256 valueToTransfer = 10;
            coin.transfer(bob, valueToTransfer);
    
            vm.stopPrank();
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
        }

    function test_simpleTransfer_FailWhenValueToTransferIsZero() public {
            vm.startPrank(coinCreator);
            vm.expectRevert(abi.encodePacked("Amount must be greater than 0"));
            coin.simpleTransfer(bob, 0);
            vm.stopPrank();
        }

    function test_simpleTransfer_FailWhenRecipientAddressIsEqualToOwnerOrTreasury() public {
            vm.startPrank(coinCreator);
    
            vm.expectRevert(abi.encodePacked("Recipient must be a valid address"));
            coin.simpleTransfer(coinCreator, 1);
    
            vm.expectRevert(abi.encodePacked("Recipient must be a valid address"));
            coin.simpleTransfer(treasury, 1);
    
            vm.stopPrank();
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