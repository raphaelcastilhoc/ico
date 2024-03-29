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

    function test_transfer_FailWhenAmountIsGreaterThan100() public {
        vm.startPrank(coinCreator);
    
        uint amount = 101;
        vm.expectRevert("Amount is too high");
        coin.transfer(alice, amount);
    
        vm.stopPrank();
    }

    function test_transfer_SuccessWhenAmountIsLessThan100() public {
        vm.startPrank(coinCreator);
    
        uint amount = 99;
        coin.transfer(alice, amount);
    
        vm.stopPrank();
    }

    function test_transfer_SuccessWhenTaxIsDisabledAndAmountIsLessThan100() public {
        vm.startPrank(coinCreator);
    
        coin.toggleTax();
        uint amount = 99;
        coin.transfer(alice, amount);
    
        vm.stopPrank();
    }
}