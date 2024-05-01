// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.18;

import "forge-std/Test.sol";
import "contracts/LendvestAjnaVault.sol";
import "./OlympixUnitTest.sol";

// interface IERC20 {
//     function balanceOf(address) external view returns (uint256);
// }

contract TestContract is OlympixUnitTest("LendvestAjnaVault") {

    //Functions fallback and receive used when the test contract is sent msg.value to prevent the test from reverting.
    fallback() external payable {}     // Fallback function is called when msg.data is not empty
    receive() external payable {}      // Function to receive Ether. msg.data must be empty

    // using stdStorage for StdStorage;
    // function writeTokenBalance(address who, address token, uint256 amt) internal {
    //     stdstore.target(token).sig(IERC20(token).balanceOf.selector).with_key(who).checked_write(amt);
    // }

    //Define events here from other contracts since Foundry has trouble importing events from other contracts still.
    // event setOpenDataEvent(address indexed user, uint newValue);
    // event setOwnerDataEvent(uint newOwnerUnixTime);
    // event donateToOwnerEvent();

    // SimpleStorage simpleStorageInstance;
    LendvestAjnaVault lendvestAjnaVault;

    function setUp() public {
        // simpleStorageInstance = new SimpleStorage();
        lendvestAjnaVault = new LendvestAjnaVault(0xEE516644509709A64906Bb1574930cdAE8659801,msg.sender);
        
        // writeTokenBalance(address(this), address(lendvestAjnaVault.weth()), 1000 ether);
        // assertEq(ERC20(address(lendvestAjnaVault.weth())).balanceOf(address(this)),1000 ether); // approving the Ajna pool to take the colletral token
        
        // deal(address(lendvestAjnaVault.weth()), address(this), 100 ether);
        // assertEq(ERC20(address(lendvestAjnaVault.weth())).balanceOf(address(this)),100 ether); // approving the Ajna pool to take the colletral token
    }



    function test_LendQuoteToken_FailWhenEpochIsStarted() public {
        vm.startPrank(address(lendvestAjnaVault.owner()));
        lendvestAjnaVault.start_epoch();
        vm.stopPrank();
    
        vm.startPrank(address(0x1));
        vm.expectRevert("epoch started");
        lendvestAjnaVault.LendQuoteToken(1);
        vm.stopPrank();
    }

    function test_LendQuoteToken_SuccessfulLend() public {
        vm.startPrank(address(0x1));
    
        lendvestAjnaVault.LendQuoteToken(1);
    
        vm.stopPrank();
    }
    

    function test_withdrawQuoteToken_FailWithdrawWhenBalanceIsInsufficient() public {
        vm.startPrank(address(0x1));
        vm.expectRevert("not have enough Quote Token");
        lendvestAjnaVault.withdrawQuoteToken(1);
        vm.stopPrank();
    }

    function test_borrow_SuccessfulBorrow() public {
        vm.startPrank(address(0x1));
    
        lendvestAjnaVault.borrow(1, 1);
    
        vm.stopPrank();
    }
    

    function test_depositColletralForLiquidation_SuccessfulDeposit() public {
        vm.startPrank(address(0x1));
    
        lendvestAjnaVault.depositColletralForLiquidation(1);
    
    //    assertEq(lendvestAjnaVault.totalAmountOfColletral(), 1);
    //    assertEq(lendvestAjnaVault.totalHelpingColletral(), 1);
    //    assertEq(lendvestAjnaVault.ColletralProviderToSuppliedAmount(address(0x1)), 1);
    
        vm.stopPrank();
    }
    

    function test_withdrawColletralofLiquidation_FailWithdrawWhenBalanceIsInsufficient() public {
        vm.startPrank(address(0x1));
        vm.expectRevert("not have enough colletral");
        lendvestAjnaVault.withdrawColletralofLiquidation(1);
        vm.stopPrank();
    }

    function test_quoteTokenAddress_SuccessfulGet() public {
        vm.startPrank(address(0x1));
        address quoteTokenAddress = lendvestAjnaVault.quoteTokenAddress();
    //    assertEq(quoteTokenAddress, address(0xEE516644509709A64906Bb1574930cdAE8659801));
        vm.stopPrank();
    }
    

    function test_getPoolAddress_SuccessfulGet() public {
        assertEq(lendvestAjnaVault.getPoolAddress(), address(lendvestAjnaVault.pool()));
    }

    function test_getCollateralAddress_SuccessfulGet() public {
        vm.startPrank(address(0x1));
        address collateralAddress = lendvestAjnaVault.getCollateralAddress();
        vm.stopPrank();
    //    assertEq(collateralAddress, address(0x0000000000000000000000000000000000001010));
    }
    

    function test_setRepaymentTime_FailWhenSenderIsNotOwner() public {
        vm.startPrank(address(0x1));
    
        vm.expectRevert("you are not an owner");
        lendvestAjnaVault.setRepaymentTime(1);
    
        vm.stopPrank();
    }

    function test_start_epoch_FailWhenSenderIsNotOwner() public {
        vm.startPrank(address(0x1));
        vm.expectRevert("you are not an owner");
        lendvestAjnaVault.start_epoch();
        vm.stopPrank();
    }

    function test_start_epoch_SuccessfulStart() public {
        vm.startPrank(address(lendvestAjnaVault.owner()));
    
        lendvestAjnaVault.start_epoch();
    
        assertEq(lendvestAjnaVault.epoch_time(), block.timestamp + 86400 * 14);
        assert(lendvestAjnaVault.epoch_started());
    
        vm.stopPrank();
    }

    function test_start_epoch_FailWhenEpochAlreadyStarted() public {
        vm.startPrank(address(lendvestAjnaVault.owner()));
    
        lendvestAjnaVault.start_epoch();
    
        vm.expectRevert("already started");
        lendvestAjnaVault.start_epoch();
    
        vm.stopPrank();
    }

    function test_endEpoch_FailWhenSenderIsNotOwner() public {
        vm.startPrank(address(0x1));
    
        vm.expectRevert("you are not an owner");
        lendvestAjnaVault.end_epoch();
    
        vm.stopPrank();
    }

    function test_endEpoch_FailWhenTimeLeftInEpochEnding() public {
        vm.startPrank(address(lendvestAjnaVault.owner()));
        lendvestAjnaVault.start_epoch();
        vm.expectRevert("time left in epoch ending");
        lendvestAjnaVault.end_epoch();
        vm.stopPrank();
    }

    function test_endEpoch_SuccessfulEnd() public {
        vm.startPrank(address(lendvestAjnaVault.owner()));
        lendvestAjnaVault.start_epoch();
        vm.warp(block.timestamp + 86400 * 14 + 1);
        lendvestAjnaVault.end_epoch();
        assert(!lendvestAjnaVault.epoch_started());
        vm.stopPrank();
    }
}