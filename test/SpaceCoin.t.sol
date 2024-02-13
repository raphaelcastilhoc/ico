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

    function test_transfer_TaxEnabled() public {
    vm.startPrank(coinCreator);

    uint256 amount = 10;
    uint256 tax = 2;
    uint256 amountAfterTax = amount - tax;

    coin.transfer(bob, amount);

    assertEq(coin.balanceOf(bob), amountAfterTax);
    assertEq(coin.balanceOf(treasury), 350000 + tax);

    vm.stopPrank();
}

    function test_transfer_TaxDisabled() public {
    vm.startPrank(coinCreator);

    coin.toggleTax();

    uint256 amount = 10;

    coin.transfer(bob, amount);

    assertEq(coin.balanceOf(bob), amount);
    assertEq(coin.balanceOf(treasury), 350000);

    vm.stopPrank();
}
}