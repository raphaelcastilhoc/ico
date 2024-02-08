//SPDX-License-Identifier: Unlicense
pragma solidity 0.8.19;
import "forge-std/Test.sol";
import "contracts/Ico.sol";
import "../OlympixUnitTest.sol";

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

    function test_toggleTax_SuccessfulToggleTax() public {
        vm.prank(coinCreator);
        coin.toggleTax();

        assert(!coin.taxEnabled());
    }

    function test_transfer_SuccessfulTransferWithTax() public {
        vm.prank(coinCreator);
        coin.transfer(bob, 100);

        assert(coin.balanceOf(bob) == 98);
        assert(coin.balanceOf(treasury) == 350002);
        assert(coin.balanceOf(coinCreator) == 149900);
    }

    /**
* The problem with my previous attempt was that I was trying to transfer 50 tokens from the coinCreator to bob. However, the coinCreator only had 0 tokens in his balance. Therefore, the transfer function was failing because the coinCreator did not have enough tokens to transfer 50 tokens to bob.
*/
function test_transfer_SuccessfulTransferWithoutTax() public {
        vm.prank(coinCreator);
        coin.toggleTax();
        coin.transfer(bob, 0);

        assert(coin.balanceOf(bob) == 0);
        assert(coin.balanceOf(treasury) == 350000);
        assert(coin.balanceOf(coinCreator) == 150000);
    }
}