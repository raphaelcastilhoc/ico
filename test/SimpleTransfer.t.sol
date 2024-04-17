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

    function test_simpleTransfer_FailWhenAmountIsGreaterThan1000() public {
        vm.startPrank(coinCreator);
    
        uint256 amount = 1001;
        vm.expectRevert("Amount is too high");
        simpleTransfer.simpleTransfer(bob, amount);
        
        vm.stopPrank();
    }

    function test_simpleTransfer_SuccessfulWhenAmountIsLessThan1000() public {
        vm.startPrank(coinCreator);
    
        uint256 amount = 999;
        simpleTransfer.simpleTransfer(bob, amount);
    
        vm.stopPrank();
    }

    function test_simpleTransfer_SuccessfulWhenAmountIsLessThan100() public {
        vm.startPrank(coinCreator);
    
        uint256 amount = 99;
        simpleTransfer.simpleTransfer(bob, amount);
    
        vm.stopPrank();
    }
}