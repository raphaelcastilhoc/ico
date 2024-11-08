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
}