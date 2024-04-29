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

    function test_transfer_FailWhenAmountIsInvalid() public {
        vm.startPrank(alice);
    
        vm.expectRevert("Amount must be greater than 0");
        coin.transfer(bob, 0);
    
        vm.stopPrank();
    }

    function test_transfer_SuccessfulTransfer() public {
        vm.startPrank(coinCreator);
    
        coin.transfer(alice, 70);
    
        assertEq(coin.balanceOf(coinCreator), 149930);
        assertEq(coin.balanceOf(alice), 68);
        assertEq(coin.balanceOf(treasury), 350002);
    
        vm.stopPrank();
    }

    function test_transfer_FailWhenRecipientIsInvalid() public {
        vm.startPrank(alice);
    
        vm.expectRevert("Recipient must be a valid address");
        coin.transfer(coinCreator, 1);
    
        vm.stopPrank();
    }

    function test_transfer_SuccessfulTransferWhenTaxIsDisabled() public {
        vm.startPrank(coinCreator);
    
        coin.toggleTax();
        coin.transfer(alice, 70);
    
        assertEq(coin.balanceOf(coinCreator), 149930);
        assertEq(coin.balanceOf(alice), 70);
        assertEq(coin.balanceOf(treasury), 350000);
    
        vm.stopPrank();
    }

    function test_transfer_FailWhenAmountIsTooHigh() public {
        vm.startPrank(coinCreator);
    
        vm.expectRevert("Amount is too high");
        coin.transfer(alice, 101);
    
        vm.stopPrank();
    }

    function test_anotherTransfer_FailTransferWhenValueIsInvalid() public {
        vm.startPrank(alice);
    
        vm.expectRevert("Amount must be greater than 0");
        coin.anotherTransfer(bob, 0);
    
        vm.stopPrank();
    }

    function test_anotherTransfer_SuccessfulTransfer() public {
        vm.startPrank(coinCreator);
    
        coin.transfer(alice, 100);
    
        vm.stopPrank();
    
        vm.startPrank(alice);
    
        coin.anotherTransfer(bob, 1);
    
    //    assertEq(coin.balanceOf(alice), 998);
    //    assertEq(coin.balanceOf(bob), 1002);
    
        vm.stopPrank();
    }
    

    function test_anotherTransfer_FailTransferWhenRecipientIsInvalid() public {
        vm.startPrank(alice);
    
        vm.expectRevert("Recipient must be a valid address");
        coin.anotherTransfer(coinCreator, 1);
    
        vm.stopPrank();
    }

    function test_anotherTransfer_FailTransferWhenValueIsTooHigh() public {
        vm.startPrank(alice);
    
        vm.expectRevert("Amount must be less than 0");
        coin.anotherTransfer(bob, 100);
    
        vm.stopPrank();
    }

    function test_toggleTax_FailWhenSenderIsNotOwner() public {
        vm.startPrank(alice);
    
        vm.expectRevert("Only owner can call this function");
        coin.toggleTax();
    
        vm.stopPrank();
    }

    function test_toggleTax_SuccessfulToggle() public {
        vm.startPrank(coinCreator);
    
        coin.toggleTax();
    
        assertEq(coin.taxEnabled(), false);
    
        vm.stopPrank();
    }
}