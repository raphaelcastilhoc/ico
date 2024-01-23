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
    vm.startPrank(coinCreator);

    coin.transfer(alice, 100);

    vm.stopPrank();

    assertEq(coin.balanceOf(alice), 98);
    assertEq(coin.balanceOf(treasury), 350000 + 2);
}

    function test_transfer_SuccessfulTransferWithoutTax() public {
    vm.startPrank(coinCreator);

    coin.toggleTax();
    coin.transfer(alice, 100);

    vm.stopPrank();

    assertEq(coin.balanceOf(alice), 100);
    assertEq(coin.balanceOf(treasury), 350000);
}
}