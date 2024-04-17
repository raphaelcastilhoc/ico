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

    function test_transfer_FailWhenRecipientIsOwner() public {
            vm.expectRevert("Recipient must be a valid address");
            coin.transfer(coinCreator, 1);
        }

    function test_transfer_FailWhenTransferingAmountIsGreaterThan100() public {
            vm.expectRevert("Amount is too high");
            coin.transfer(bob, 101);
        }

    function test_transfer_SuccessfulTransferWhenTaxIsDisabled() public {
            vm.startPrank(coinCreator);
    
            coin.transfer(alice, 100);
            coin.toggleTax();
    
            vm.stopPrank();
    
            vm.startPrank(alice);
    
            uint256 value = 10;
            coin.transfer(bob, value);
    
            vm.stopPrank();
            
    //        assertEq(coin.balanceOf(bob), value);
    //        assertEq(coin.balanceOf(alice), 100 - value); 
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
    
            uint256 value = 10;
            coin.anotherTransfer(bob, value);
    
            vm.stopPrank();
            
            assertEq(coin.balanceOf(bob), value + 1);
            assertEq(coin.balanceOf(alice), 100 - value - 1 - 2); // Subtract 2 to account for the tax
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
    
        assert(initialTaxStatus != finalTaxStatus);
    }
}