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

    function test_transfer_FailTransferWhenAmountIsInvalid() public {
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

    function test_transfer_FailTransferWhenRecipientIsInvalid() public {
        vm.startPrank(alice);
    
        vm.expectRevert("Recipient must be a valid address");
        coin.transfer(coinCreator, 1);
    
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

    function test_transfer_FailTransferWhenAmountIsTooHigh() public {
        vm.startPrank(alice);
    
        vm.expectRevert("Amount is too high");
        coin.transfer(bob, 101);
    
        vm.stopPrank();
    }

    function test_anotherTransfer_FailTransferWhenValueIsInvalid() public {
        vm.startPrank(alice);
    
        vm.expectRevert("Amount must be greater than 0");
        coin.anotherTransfer(bob, 0);
    
        vm.stopPrank();
    }

    function test_anotherTransfer_SuccessfulTransfer() public {
        vm.startPrank(alice);
    
        coin.anotherTransfer(bob, 1);
    
    //    assertEq(coin.balanceOf(alice), 999);
    //    assertEq(coin.balanceOf(bob), 1001);
    
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
}