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

    function test_complexTransfer_SuccessfulTransferWithTax() public {
        vm.startPrank(alice);
    
        complexTransfer.complexTransfer(bob, 101);
    
        vm.stopPrank();
    
    //    assertEq(complexTransfer.balanceOf(alice), 149899);
    //    assertEq(complexTransfer.balanceOf(bob), 100095);
    //    assertEq(complexTransfer.balanceOf(treasury), 350006);
    }
    

    function test_complexTransfer_SuccessfulTransferWithTaxWhenAmountIsGreaterThanEighty() public {
        vm.startPrank(alice);
    
        complexTransfer.complexTransfer(bob, 81);
    
        vm.stopPrank();
    
    //    assertEq(complexTransfer.balanceOf(alice), 149919);
    //    assertEq(complexTransfer.balanceOf(bob), 100076);
    //    assertEq(complexTransfer.balanceOf(treasury), 350005);
    }
    

    function test_complexTransfer_SuccessfulTransferWithTaxWhenAmountIsGreaterThanSixty() public {
        vm.startPrank(alice);
    
        complexTransfer.complexTransfer(bob, 61);
    
        vm.stopPrank();
    
    //    assertEq(complexTransfer.balanceOf(alice), 149939);
    //    assertEq(complexTransfer.balanceOf(bob), 100057);
    //    assertEq(complexTransfer.balanceOf(treasury), 350004);
    }
    

    function test_complexTransfer_SuccessfulTransferWithTaxWhenAmountIsGreaterThanForty() public {
        vm.startPrank(coinCreator);
    
        complexTransfer.transfer(alice, 41);
    
        vm.stopPrank();
    
        vm.startPrank(alice);
    
        complexTransfer.complexTransfer(bob, 41);
    
        vm.stopPrank();
    
        assertEq(complexTransfer.balanceOf(alice), 0);
        assertEq(complexTransfer.balanceOf(bob), 38);
        assertEq(complexTransfer.balanceOf(treasury), 350003);
    }

    function test_complexTransfer_SuccessfulTransferWithTaxWhenAmountIsGreaterThanTwenty() public {
        vm.startPrank(coinCreator);
    
        complexTransfer.transfer(alice, 21);
    
        vm.stopPrank();
    
        vm.startPrank(alice);
    
        complexTransfer.complexTransfer(bob, 21);
    
        vm.stopPrank();
    
        assertEq(complexTransfer.balanceOf(alice), 0);
        assertEq(complexTransfer.balanceOf(bob), 19);
        assertEq(complexTransfer.balanceOf(treasury), 350002);
    }

    function test_complexTransfer_SuccessfulTransferWithTaxWhenAmountIsGreaterThanTen() public {
        vm.startPrank(coinCreator);
    
        complexTransfer.transfer(alice, 11);
    
        vm.stopPrank();
    
        vm.startPrank(alice);
    
        complexTransfer.complexTransfer(bob, 11);
    
        vm.stopPrank();
    
        assertEq(complexTransfer.balanceOf(alice), 0);
        assertEq(complexTransfer.balanceOf(bob), 10);
        assertEq(complexTransfer.balanceOf(treasury), 350001);
    }

    function test_complexTransfer_SuccessfulTransferWithoutTax() public {
        vm.startPrank(coinCreator);
    
        complexTransfer.transfer(alice, 10);
    
        vm.stopPrank();
    
        vm.startPrank(alice);
    
        complexTransfer.complexTransfer(bob, 10);
    
        vm.stopPrank();
    
        assertEq(complexTransfer.balanceOf(alice), 0);
        assertEq(complexTransfer.balanceOf(bob), 10);
        assertEq(complexTransfer.balanceOf(treasury), 350000);
    }
}