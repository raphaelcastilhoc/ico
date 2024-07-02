//SPDX-License-Identifier: Unlicense
pragma solidity 0.8.19;

import "forge-std/Test.sol";
import "contracts/Ico.sol";
import "contracts/SimpleTransfer.sol";
import "./OlympixUnitTest.sol";

contract SimpleTransferTest is OlympixUnitTest("SimpleTransfer") {
    address alice = address(0x456);
    address bob = address(0x789);
    address treasury = address(0xabc);
    address coinCreator = address(0xff);
    SimpleTransfer simpleTransfer;

    function setUp() public {
        vm.deal(coinCreator, 1000);
        vm.deal(alice, 1000);
        vm.deal(bob, 1000);

        vm.startPrank(coinCreator);
        simpleTransfer = new SimpleTransfer(treasury, coinCreator);
        vm.stopPrank();

        deal(address(simpleTransfer), alice, 1000);
        deal(address(simpleTransfer), bob, 1000);
    }

    function test_simpleTransfer_FailWhenAmountIsTooHigh() public {
        vm.startPrank(alice);
        uint256 amount = 1001;
        vm.expectRevert("Amount is too high");
        simpleTransfer.simpleTransfer(bob, amount);
        vm.stopPrank();
    }

    function test_simpleTransfer_SuccessfulTransfer() public {
        vm.startPrank(alice);
        uint256 amount = 100;
        simpleTransfer.simpleTransfer(bob, amount);
        vm.stopPrank();
    
        assertEq(simpleTransfer.balanceOf(alice), 900);
        assertEq(simpleTransfer.balanceOf(bob), 1100);
        assertEq(simpleTransfer.balanceOf(treasury), 350000);
    }

    function test_simpleTransfer_SuccessfulTransferWithTax() public {
        vm.startPrank(alice);
        uint256 amount = 200;
        simpleTransfer.simpleTransfer(bob, amount);
        vm.stopPrank();
    
        assertEq(simpleTransfer.balanceOf(alice), 800);
        assertEq(simpleTransfer.balanceOf(bob), 1198);
        assertEq(simpleTransfer.balanceOf(treasury), 350002);
    }
}