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

    function test_SpaceCoin_transfer_TaxEnabled() public {
        vm.startPrank(coinCreator);
        coin.transfer(bob, 1000);
        vm.stopPrank();
        assertTrue(coin.balanceOf(bob) == 998, "bob should have 9800 coins");
        assertTrue(coin.balanceOf(treasury) == 350002, "treasury should have 350200 coins");
    }

    function test_SpaceCoin_transfer_TaxDisabled() public {
        vm.startPrank(coinCreator);
        coin.toggleTax();
        coin.transfer(bob, 10000);
        vm.stopPrank();
        assertTrue(coin.balanceOf(bob) == 10000, "bob should have 10000 coins");
        assertTrue(coin.balanceOf(treasury) == 350000, "treasury should have 350000 coins");
    }
}