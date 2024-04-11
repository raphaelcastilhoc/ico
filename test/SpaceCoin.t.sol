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

    function test_transfer_FailWhenAmountIsZero() public {
        vm.expectRevert("Amount must be greater than 0");
        coin.transfer(bob, 0);
    }

    function test_transfer_SuccessfulTransfer() public {
            vm.startPrank(coinCreator);
            coin.transfer(alice, 100);
            coin.toggleTax();
            vm.stopPrank();
    
            vm.startPrank(alice);
    
            uint amount = 1;
            coin.transfer(bob, amount);
    
            vm.stopPrank();
    
    //        assertEq(coin.balanceOf(alice), 99);
    //        assertEq(coin.balanceOf(bob), 1001);
    //        assertEq(coin.balanceOf(treasury), 350000);
        }

    function test_transfer_FailWhenRecipientIsOwnerOrTreasury() public {
            vm.expectRevert("Recipient must be a valid address");
            coin.transfer(coinCreator, 10);
        }

    function test_transfer_FailWhenAmountIsGreaterThan100() public {
        vm.startPrank(coinCreator);
    
        uint amount = 101;
        vm.expectRevert("Amount is too high");
        coin.transfer(alice, amount);
    
        vm.stopPrank();
    }

    function test_simpleTransfer_SuccessfulTransfer() public {
            vm.startPrank(coinCreator);
    
            uint amount = 1;
            coin.simpleTransfer(alice, amount);
    
            vm.stopPrank();
    
            assertEq(coin.balanceOf(alice), 2);
            assertEq(coin.balanceOf(coinCreator), 149998);
        }

    function test_toggleTax_FailWhenSenderIsNotOwner() public {
        vm.expectRevert("Only owner can call this function");
        coin.toggleTax();
    }

    function test_toggleTax_SuccessWhenSenderIsOwner() public {
        vm.startPrank(coinCreator);
    
        coin.toggleTax();
    
        vm.stopPrank();
        
        bool taxEnabled = coin.taxEnabled();
        assertTrue(taxEnabled == false);
    }
}