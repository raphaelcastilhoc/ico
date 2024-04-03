//SPDX-License-Identifier: Unlicense
pragma solidity 0.8.19;

import "forge-std/Test.sol";
import "contracts/Ico.sol";
import "contracts/SimpleTransfer.sol";
import "./OlympixUnitTest.sol";

contract SimpleTransferTest is OlympixUnitTest("SimpleTransfer") {
    address alice = address(0x456);
    address bob = address(0x789);
    address treasury = address(0xabc);
    address coinCreator = address(0xff);
    SimpleTransfer simpleTransfer;

    function setUp() public {
        vm.deal(coinCreator, 1000);
        vm.deal(alice, 1000);
        vm.deal(bob, 1000);

        vm.startPrank(coinCreator);
        simpleTransfer = new SimpleTransfer(treasury, coinCreator);
        vm.stopPrank();
    }

    /**
    * The problem with my previous attempt was that I was subtracting the gas fee from the sender's final balance. However, the gas fee is not deducted from the sender's balance in the SimpleTransfer contract, but from the sender's balance in the Ethereum network. Therefore, the sender's final balance in the SimpleTransfer contract is simply the initial balance minus the sent amount.
    */
    function test_transfer_AmountGreaterThan100() public {
        uint256 initialSenderBalance = simpleTransfer.balanceOf(coinCreator);
        uint256 initialRecipientBalance = simpleTransfer.balanceOf(bob);
        uint256 initialTreasuryBalance = simpleTransfer.balanceOf(treasury);
    
        uint256 amount = 150;
        uint256 tax = 2;
    
        vm.startPrank(coinCreator);
    
        simpleTransfer.transfer(bob, amount);
    
        vm.stopPrank();
    
        uint256 finalSenderBalance = simpleTransfer.balanceOf(coinCreator);
        uint256 finalRecipientBalance = simpleTransfer.balanceOf(bob);
        uint256 finalTreasuryBalance = simpleTransfer.balanceOf(treasury);
    
        assertEq(finalSenderBalance, initialSenderBalance - amount);
        assertEq(finalRecipientBalance, initialRecipientBalance + amount - tax);
        assertEq(finalTreasuryBalance, initialTreasuryBalance + tax);
    }

    function test_transfer_AmountLessThanOrEqualTo100() public {
        uint256 initialSenderBalance = simpleTransfer.balanceOf(coinCreator);
        uint256 initialRecipientBalance = simpleTransfer.balanceOf(bob);
    
        uint256 amount = 100;
    
        vm.startPrank(coinCreator);
    
        simpleTransfer.transfer(bob, amount);
    
        vm.stopPrank();
    
        uint256 finalSenderBalance = simpleTransfer.balanceOf(coinCreator);
        uint256 finalRecipientBalance = simpleTransfer.balanceOf(bob);
    
        assertEq(finalSenderBalance, initialSenderBalance - amount);
        assertEq(finalRecipientBalance, initialRecipientBalance + amount);
    }
}