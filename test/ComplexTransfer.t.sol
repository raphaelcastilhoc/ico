//SPDX-License-Identifier: Unlicense
pragma solidity 0.8.19;

import "forge-std/Test.sol";
import "contracts/Ico.sol";
import "contracts/ComplexTransfer.sol";
import "./OlympixUnitTest.sol";

contract ComplexTransferTest is OlympixUnitTest("ComplexTransfer") {
    address alice = address(0x456);
    address bob = address(0x789);
    address treasury = address(0xabc);
    address coinCreator = address(0xff);
    ComplexTransfer complexTransfer;

    function setUp() public {
        vm.deal(coinCreator, 1000);
        vm.deal(alice, 1000);
        vm.deal(bob, 1000);

        vm.startPrank(coinCreator);
        complexTransfer = new ComplexTransfer(treasury, coinCreator);
        vm.stopPrank();
    }

    function test_transfer_SuccessfulTransferWithTaxWhenAmountIsGreaterThan100() public {
        uint256 amount = 101;
        uint256 tax = 6;
    
        vm.startPrank(coinCreator);
    
        complexTransfer.transfer(bob, amount);
    
        assertEq(complexTransfer.balanceOf(coinCreator), 150000 - amount);
        assertEq(complexTransfer.balanceOf(bob), amount - tax);
        assertEq(complexTransfer.balanceOf(treasury), 350000 + tax);
    
        vm.stopPrank();
    }

    function test_transfer_SuccessfulTransferWithTaxWhenAmountIsGreaterThan80AndLessThanOrEqualTo100() public {
        uint256 amount = 81;
        uint256 tax = 5;
    
        vm.startPrank(coinCreator);
    
        complexTransfer.transfer(bob, amount);
    
        assertEq(complexTransfer.balanceOf(coinCreator), 150000 - amount);
        assertEq(complexTransfer.balanceOf(bob), amount - tax);
        assertEq(complexTransfer.balanceOf(treasury), 350000 + tax);
    
        vm.stopPrank();
    }

    function test_transfer_SuccessfulTransferWithTaxWhenAmountIsGreaterThan60AndLessThanOrEqualTo80() public {
        uint256 amount = 61;
        uint256 tax = 4;
    
        vm.startPrank(coinCreator);
    
        complexTransfer.transfer(bob, amount);
    
        assertEq(complexTransfer.balanceOf(coinCreator), 150000 - amount);
        assertEq(complexTransfer.balanceOf(bob), amount - tax);
        assertEq(complexTransfer.balanceOf(treasury), 350000 + tax);
    
        vm.stopPrank();
    }

    function test_transfer_SuccessfulTransferWithTaxWhenAmountIsGreaterThan40AndLessThanOrEqualTo60() public {
            uint256 amount = 41;
            uint256 tax = 3;
        
            vm.startPrank(coinCreator);
        
            complexTransfer.transfer(bob, amount);
        
            assertEq(complexTransfer.balanceOf(coinCreator), 150000 - amount);
            assertEq(complexTransfer.balanceOf(bob), amount - tax);
            assertEq(complexTransfer.balanceOf(treasury), 350000 + tax);
        
            vm.stopPrank();
        }

    function test_transfer_SuccessfulTransferWithTaxWhenAmountIsGreaterThan20AndLessThanOrEqualTo40() public {
        uint256 amount = 21;
        uint256 tax = 2;
    
        vm.startPrank(coinCreator);
    
        complexTransfer.transfer(bob, amount);
    
        assertEq(complexTransfer.balanceOf(coinCreator), 150000 - amount);
        assertEq(complexTransfer.balanceOf(bob), amount - tax);
        assertEq(complexTransfer.balanceOf(treasury), 350000 + tax);
    
        vm.stopPrank();
    }

    function test_transfer_SuccessfulTransferWithTaxWhenAmountIsGreaterThan10AndLessThanOrEqualTo20() public {
        uint256 amount = 11;
        uint256 tax = 1;
    
        vm.startPrank(coinCreator);
    
        complexTransfer.transfer(bob, amount);
    
        assertEq(complexTransfer.balanceOf(coinCreator), 150000 - amount);
        assertEq(complexTransfer.balanceOf(bob), amount - tax);
        assertEq(complexTransfer.balanceOf(treasury), 350000 + tax);
    
        vm.stopPrank();
    }

    function test_transfer_SuccessfulTransferWhenAmountIsLessThanOrEqualTo10() public {
        uint256 amount = 10;
    
        vm.startPrank(coinCreator);
    
        complexTransfer.transfer(bob, amount);
    
        assertEq(complexTransfer.balanceOf(coinCreator), 150000 - amount);
        assertEq(complexTransfer.balanceOf(bob), amount);
        assertEq(complexTransfer.balanceOf(treasury), 350000);
    
        vm.stopPrank();
    }
}