//SPDX-License-Identifier: Unlicense
pragma solidity 0.8.19;
import "forge-std/Test.sol";
import "contracts/Ico.sol";
import "./OlympixUnitTest.sol";

contract SpaceCoinTest is OlympixUnitTest("SpaceCoin")  {
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

    function test_transfer_SuccessfulTransferWhenTaxIsEnabled() public {
    uint transferAmount = 10;
    vm.prank(coinCreator);
    coin.transfer(alice, transferAmount);
    vm.stopPrank();

    uint tax = 2;
    uint amountAfterTax = transferAmount - tax;
    assertEq(coin.balanceOf(coinCreator), 150000 - transferAmount);
    assertEq(coin.balanceOf(alice), amountAfterTax);
    assertEq(coin.balanceOf(treasury), 350000 + tax);
}

    function test_transfer_SuccessfulTransferWhenTaxIsDisabled() public {
    vm.prank(coinCreator);
    coin.toggleTax();
    vm.stopPrank();

    uint transferAmount = 10;
    vm.prank(coinCreator);
    coin.transfer(alice, transferAmount);
    vm.stopPrank();

    assertEq(coin.balanceOf(coinCreator), 150000 - transferAmount);
    assertEq(coin.balanceOf(alice), transferAmount);
}
}