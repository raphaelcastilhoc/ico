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

        deal(address(coin), alice, 1000);
        deal(address(coin), bob, 1000);
    }

    function test_transfer_FailWhenTransferingAmountIsInvalid() public {
        vm.startPrank(alice);
    
        vm.expectRevert("Amount must be greater than 0");
        coin.transfer(bob, 0);
    
        vm.stopPrank();
    }

    function test_transfer_SuccessfulTransfer() public {
        vm.startPrank(alice);
    
        coin.transfer(bob, 10);
    
        assertEq(coin.balanceOf(alice), 990);
        assertEq(coin.balanceOf(bob), 1008);
        assertEq(coin.balanceOf(treasury), 350002);
    
        vm.stopPrank();
    }

    function test_transfer_FailWhenRecipientIsInvalid() public {
        vm.startPrank(alice);
    
        vm.expectRevert("Recipient must be a valid address");
        coin.transfer(coinCreator, 10);
    
        vm.stopPrank();
    }

    function test_transfer_SuccessfulTransferWhenTaxIsDisabled() public {
        vm.startPrank(coinCreator);
        coin.toggleTax();
        vm.stopPrank();
    
        vm.startPrank(alice);
    
        coin.transfer(bob, 10);
    
        assertEq(coin.balanceOf(alice), 990);
        assertEq(coin.balanceOf(bob), 1010);
        assertEq(coin.balanceOf(treasury), 350000);
    
        vm.stopPrank();
    }

    function test_checkIfAmountIsValid_FailWhenAmountIsTooHigh() public {
        vm.startPrank(alice);
    
        vm.expectRevert("Amount is too high");
        coin.transfer(bob, 101);
    
        vm.stopPrank();
    }

    function test_anotherTransfer_FailWhenValueIsInvalid() public {
        vm.startPrank(alice);
    
        vm.expectRevert("Amount must be greater than 0");
        coin.anotherTransfer(bob, 0);
    
        vm.stopPrank();
    }

    function test_anotherTransfer_SuccessfulTransfer() public {
        vm.startPrank(alice);
    
        coin.anotherTransfer(bob, 10);
    
        assertEq(coin.balanceOf(alice), 989);
        assertEq(coin.balanceOf(bob), 1011);
    
        vm.stopPrank();
    }

    function test_anotherTransfer_FailWhenRecipientIsInvalid() public {
        vm.startPrank(alice);
    
        vm.expectRevert("Recipient must be a valid address");
        coin.anotherTransfer(coinCreator, 10);
    
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