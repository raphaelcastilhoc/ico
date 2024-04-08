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

    function test_transfer_SuccessfulTransferWhenAmountIsLessThan1000() public {
        vm.startPrank(coinCreator);
    
        uint256 amount = 999;
        simpleTransfer.transfer(bob, amount);
    
        vm.stopPrank();
        
    //    assert(simpleTransfer.balanceOf(coinCreator) == 150000 - amount);
    //    assert(simpleTransfer.balanceOf(bob) == amount);
    }
    

    function test_transfer_SuccessfulTransferWhenAmountIsLessThan100() public {
        vm.startPrank(coinCreator);
    
        uint256 amount = 99;
        simpleTransfer.transfer(bob, amount);
    
        vm.stopPrank();
        
        assert(simpleTransfer.balanceOf(coinCreator) == 150000 - amount);
        assert(simpleTransfer.balanceOf(bob) == amount);
    }
}