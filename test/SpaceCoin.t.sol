/*
// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
import "forge-std/test.sol";
import "contracts/SpaceCoin.sol";

contract SpaceCoinTest is Test {

    address owner = address(0x234);
    address alice = address(0x456);
    address bob = address(0x789);
    address charlie = address(0xabc);
    address treasury = address(0xdef);
    SpaceCoin coin;


    function setUp() public {
        treasury = address(1);
        vm.startPrank(owner);
        coin = new SpaceCoin(treasury, owner);
        vm.stopPrank();
    }

    function testInitialSupply() public {
        assertEq(coin.balanceOf(owner), 150000);
        assertEq(coin.balanceOf(treasury), 350000);
    }

    function testTransfer() public {
        vm.startPrank(owner);
        coin.transfer(alice, 1000);
        assertEq(coin.balanceOf(alice), 980, "Alice should have 9800 coins");
        assertEq(coin.balanceOf(owner), 149000, "Owner should have 149000 coins");
        assertEq(coin.balanceOf(treasury), 350020, "Treasury should have 350200 coins");
    }

}
*/