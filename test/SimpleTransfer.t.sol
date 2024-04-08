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
    }

    function test_transfer_FailWhenAmountIsGreaterThan1000() public {
        vm.startPrank(coinCreator);
    
        uint256 amount = 1001;
        vm.expectRevert("Amount is too high");
        simpleTransfer.transfer(bob, amount);
    
        vm.stopPrank();
    }

    /**
    * The problem with my previous attempt was that I didn't consider the tax that is deducted when the amount is greater than 100. The tax is 2, so the amount that bob receives is 997, not 999.
    */
    function test_transfer_SuccessfulTransferWhenAmountIsLessThan1000() public {
        vm.startPrank(coinCreator);
    
        uint256 amount = 999;
        simpleTransfer.transfer(bob, amount);
    
        vm.stopPrank();
        
        assertEq(simpleTransfer.balanceOf(coinCreator), 150000 - amount);
        assertEq(simpleTransfer.balanceOf(bob), amount - 2);
    }

    function test_transfer_SuccessfulTransferWhenAmountIsGreaterThan100() public {
        vm.startPrank(coinCreator);
    
        uint256 amount = 101;
        simpleTransfer.transfer(bob, amount);
    
        vm.stopPrank();
        
        assertEq(simpleTransfer.balanceOf(coinCreator), 150000 - amount);
        assertEq(simpleTransfer.balanceOf(bob), amount - 2);
        assertEq(simpleTransfer.balanceOf(treasury), 350000 + 2);
    }

    function test_transfer_SuccessfulTransferWhenAmountIsLessThan100() public {
            vm.startPrank(coinCreator);
        
            uint256 amount = 99;
            simpleTransfer.transfer(bob, amount);
        
            vm.stopPrank();
            
            assertEq(simpleTransfer.balanceOf(coinCreator), 150000 - amount);
            assertEq(simpleTransfer.balanceOf(bob), amount);
        }
}