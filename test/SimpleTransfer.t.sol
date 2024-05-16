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

    function test_simpleTransfer_FailWhenAmountIsGreaterThan1000() public {
        vm.startPrank(alice);
    
        vm.expectRevert("Amount is too high");
        simpleTransfer.simpleTransfer(bob, 1001);
    
        vm.stopPrank();
    }

    function test_simpleTransfer_SuccessfulTransfer() public {
        vm.startPrank(alice);
    
        simpleTransfer.simpleTransfer(bob, 100);
    
        vm.stopPrank();
    
    //    assertEq(simpleTransfer.balanceOf(alice), 900);
    //    assertEq(simpleTransfer.balanceOf(bob), 1100);
    //    assertEq(simpleTransfer.balanceOf(treasury), 1000);
    }
    

    function test_simpleTransfer_SuccessfulTransferWhenAmountIsGreaterThan100() public {
        vm.startPrank(alice);
    
        simpleTransfer.simpleTransfer(bob, 101);
    
        vm.stopPrank();
    
        assertEq(simpleTransfer.balanceOf(alice), 899);
        assertEq(simpleTransfer.balanceOf(bob), 1099);
        assertEq(simpleTransfer.balanceOf(treasury), 350002);
    }
}