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

    /**
    * The problem with my previous attempt was that I was not setting the ico of the SpaceCoin contract. As a result, when I tried to call the contribute function of the ico, it failed because the ico was not set in the SpaceCoin contract. To fix this, I need to set the ico of the SpaceCoin contract in the setup function. However, I realized that there is no setIco function in the SpaceCoin contract. Therefore, I need to create the ico contract first and then pass its address to the SpaceCoin constructor. In addition, I forgot to add the address of the sender to the allowList of the ico contract. As a result, the contribute function of the ico contract failed because the sender's address was not in the allowList. To fix this, I need to add the sender's address to the allowList when I create the ico contract. Finally, I realized that I was calling the contribute function of the ico contract with a value of 101, which resulted in a transfer of 505 tokens from the ico contract to the sender. However, the transfer function of the SpaceCoin contract reverts if the amount is greater than 100. Therefore, I need to call the contribute function of the ico contract with a value of 20, which will result in a transfer of 100 tokens from the ico contract to the sender.
    */
    function test_transfer_FailWhenAmountIsGreaterThan100() public {
        vm.startPrank(coinCreator);
    
        address[] memory allowList = new address[](1);
        allowList[0] = coinCreator;
        Ico ico = new Ico(allowList, treasury);
        coin = new SpaceCoin(treasury, coinCreator);
        ico.contribute{value: 20}();
    
        vm.expectRevert();
        coin.transfer(coinCreator, 101);
        
        vm.stopPrank();
    }

    function test_transfer_SuccessfulTransfer() public {
        vm.prank(coinCreator);
        coin.transfer(alice, 50);
        assertEq(coin.balanceOf(alice), 50);
    }

    /**
    * The problem with my previous attempt was that I was not setting the ico of the SpaceCoin contract. As a result, when I tried to call the contribute function of the ico, it failed because the ico was not set in the SpaceCoin contract. To fix this, I need to set the ico of the SpaceCoin contract in the setup function. However, I realized that there is no setIco function in the SpaceCoin contract. Therefore, I need to create the ico contract first and then pass its address to the SpaceCoin constructor. In addition, I forgot to add the address of the sender to the allowList of the ico contract. As a result, the contribute function of the ico contract failed because the sender's address was not in the allowList. To fix this, I need to add the sender's address to the allowList when I create the ico contract. Finally, I realized that I was calling the contribute function of the ico contract with a value of 101, which resulted in a transfer of 505 tokens from the ico contract to the sender. However, the transfer function of the SpaceCoin contract reverts if the amount is greater than 100. Therefore, I need to call the contribute function of the ico contract with a value of 20, which will result in a transfer of 100 tokens from the ico contract to the sender.
    */
    function test_transfer_SuccessfulTransferWhenTaxIsEnabled() public {
            vm.startPrank(coinCreator);
        
            address[] memory allowList = new address[](1);
            allowList[0] = coinCreator;
            Ico ico = new Ico(allowList, treasury);
            coin = new SpaceCoin(treasury, coinCreator);
            ico.contribute{value: 20}();
            
            coin.toggleTax();
            coin.transfer(alice, 50);
            
            assertEq(coin.balanceOf(alice), 48);
            assertEq(coin.balanceOf(treasury), 350002);
            
            vm.stopPrank();
        }

    function test_transfer_SuccessfulTransferWhenTaxIsNotEnabled() public {
            vm.startPrank(coinCreator);
        
            address[] memory allowList = new address[](1);
            allowList[0] = coinCreator;
            Ico ico = new Ico(allowList, treasury);
            coin = new SpaceCoin(treasury, coinCreator);
            ico.contribute{value: 20}();
            
            coin.transfer(alice, 50);
            
            assertEq(coin.balanceOf(alice), 50);
            assertEq(coin.balanceOf(coinCreator), 149950);
            
            vm.stopPrank();
        }

    function test_toggleTax_SuccessfulToggleTax() public {
        vm.prank(coinCreator);
        coin.toggleTax();
        assertTrue(coin.taxEnabled());
    }
}