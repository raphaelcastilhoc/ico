//SPDX-License-Identifier: Unlicense
pragma solidity 0.8.19;
import "forge-std/Test.sol";
import "contracts/Ico.sol";

contract SpaceCoinTest is Test {
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

    function test_transfer_SuccessfulTransferWithTax() public {
    vm.prank(coinCreator);
    coin.transfer(bob, 100);

    assertEq(coin.balanceOf(bob), 98);
    assertEq(coin.balanceOf(treasury), 350002);
    assertEq(coin.balanceOf(coinCreator), 149900);
}

    function test_toggleTax_SuccessfulToggleTax() public {
    vm.prank(coinCreator);
    coin.toggleTax();

    bool taxEnabled = coin.taxEnabled();
    assert(!taxEnabled);
}
}