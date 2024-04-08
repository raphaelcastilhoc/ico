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

    /**
    * The problem with my previous attempt was that I was not considering that the balance of bob was being updated inside the transfer function, so when I was asserting the balance of bob I was considering the initial balance (1000) plus the amount transferred (101 - 2), but in fact the balance of bob was being updated to 99 inside the transfer function, so the correct assertion would be assertEq(simpleTransfer.balanceOf(bob), 99);
    */
    function test_transfer_AmountGreaterThan100() public {
        vm.startPrank(coinCreator);
    
        simpleTransfer.transfer(bob, 101);
    
        vm.stopPrank();
    
        assertEq(simpleTransfer.balanceOf(coinCreator), 150000 - 101);
        assertEq(simpleTransfer.balanceOf(bob), 99);
        assertEq(simpleTransfer.balanceOf(treasury), 350000 + 2);
    }

    function test_transfer_AmountLessThan100() public {
        vm.startPrank(coinCreator);
    
        simpleTransfer.transfer(bob, 99);
    
        vm.stopPrank();
    
        assertEq(simpleTransfer.balanceOf(coinCreator), 150000 - 99);
        assertEq(simpleTransfer.balanceOf(bob), 99);
        assertEq(simpleTransfer.balanceOf(treasury), 350000);
    }
}