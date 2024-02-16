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

    function test_transfer_SuccessfulTransferWithTax() public {
    vm.prank(coinCreator);
    coin.transfer(alice, 10);
    
    assertEq(coin.balanceOf(alice), 8);
    assertEq(coin.balanceOf(treasury), 350002);
    assertEq(coin.balanceOf(coinCreator), 149990);
}

    function test_fakeTransfer_SuccessfulFakeTransfer() public {
    vm.prank(coinCreator);
    coin.fakeTransfer(alice, 10);
    
    assertEq(coin.balanceOf(alice), 8);
    assertEq(coin.balanceOf(treasury), 350002);
    assertEq(coin.balanceOf(coinCreator), 149990);
}

    /**
* The problem with my previous attempt was that I was calling vm.stopPrank() without having a prank in progress. I should have removed that line of code because vm.prank() does not start a prank, it just sets the msg.sender for the next transaction.
*/
function test_toggleTax_SuccessfulToggleTax() public {
    vm.prank(coinCreator);
    coin.toggleTax();
    bool taxStatus = coin.taxEnabled();
    assert(!taxStatus);
}
}