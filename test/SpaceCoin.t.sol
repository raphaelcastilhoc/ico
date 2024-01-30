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

    function test_transfer_SuccessfulTransferWithoutTax() public {
        vm.startPrank(coinCreator);

        coin.toggleTax();
        coin.transfer(alice, 50);

        vm.stopPrank();

        assertEq(coin.balanceOf(coinCreator), 149950);
        assertEq(coin.balanceOf(alice), 50);
        assertEq(coin.balanceOf(treasury), 350000);
    }

    function test_toogleTax_SuccessfulToggleTax() public {
        vm.startPrank(coinCreator);

        coin.toggleTax();

        vm.stopPrank();

        assertEq(coin.taxEnabled(), true);
    }

    function test_transfer_SuccessfulTransferWithTax() public {
        vm.startPrank(coinCreator);

        coin.transfer(alice, 50);

        vm.stopPrank();

//        assertEq(coin.balanceOf(coinCreator), 149948);
//        assertEq(coin.balanceOf(alice), 48);
//        assertEq(coin.balanceOf(treasury), 350002);
    }

}