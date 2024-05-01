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
    address alice;

    function setUp() public {
        alice = address(1);
        // simpleStorageInstance = new SimpleStorage();
        lendvestAjnaVault = new LendvestAjnaVault(0xEE516644509709A64906Bb1574930cdAE8659801,msg.sender);
        
        // writeTokenBalance(address(this), address(lendvestAjnaVault.weth()), 1000 ether);
        // assertEq(ERC20(address(lendvestAjnaVault.weth())).balanceOf(address(this)),1000 ether); // approving the Ajna pool to take the colletral token
        
        // deal(address(lendvestAjnaVault.weth()), address(this), 100 ether);
        // assertEq(ERC20(address(lendvestAjnaVault.weth())).balanceOf(address(this)),100 ether); // approving the Ajna pool to take the colletral token
    }

    

    function test_withdrawQuoteToken_FailWithdrawWhenBalanceIsInsufficient() public {
        vm.startPrank(alice);
    
        vm.expectRevert("not have enough Quote Token");
        lendvestAjnaVault.withdrawQuoteToken(1);
    
        vm.stopPrank();
    }

    function test_borrow_SuccessfulBorrow() public {
        vm.startPrank(alice);
    
        lendvestAjnaVault.borrow(1, 1);
    
    //    assertEq(lendvestAjnaVault.BorrowerToColletralAmount(alice), 1);
    //    assertEq(lendvestAjnaVault.BorrowerToBorrowAmount(alice), 1);
    //    assertEq(lendvestAjnaVault.totalAmountOfColletral(), 1);
    //    assertEq(lendvestAjnaVault.totalAmountOfBorrowed(), 1);
    
        vm.stopPrank();
    }
    

    function test_depositColletralForLiquidation_SuccessfulDeposit() public {
        vm.startPrank(alice);
    
        lendvestAjnaVault.depositColletralForLiquidation(100);
    
    //    assertEq(lendvestAjnaVault.totalAmountOfColletral(), 100);
    //    assertEq(lendvestAjnaVault.totalHelpingColletral(), 100);
    //    assertEq(lendvestAjnaVault.ColletralProviderToSuppliedAmount(alice), 100);
    
        vm.stopPrank();
    }
    

    function test_withdrawColletralofLiquidation_FailWithdrawWhenBalanceIsInsufficient() public {
        vm.startPrank(alice);
    
        vm.expectRevert("not have enough colletral");
        lendvestAjnaVault.withdrawColletralofLiquidation(1);
    
        vm.stopPrank();
    }

    function test_quoteTokenAddress_SuccessfulGet() public {
        vm.startPrank(address(lendvestAjnaVault.owner()));
    
        address quoteTokenAddress = lendvestAjnaVault.quoteTokenAddress();
    
    //    assertEq(quoteTokenAddress, address(lendvestAjnaVault.pool().quoteTokenAddress()));
    
        vm.stopPrank();
    }
    

    function test_getPoolAddress_SuccessfulGet() public {
        assertEq(lendvestAjnaVault.getPoolAddress(), address(lendvestAjnaVault.pool()));
    }

    function test_getCollateralAddress_SuccessfulGet() public {
        vm.startPrank(address(lendvestAjnaVault.owner()));
    
        address collateralAddress = lendvestAjnaVault.getCollateralAddress();
    
    //    assertEq(collateralAddress, address(lendvestAjnaVault.pool().collateralAddress()));
    
        vm.stopPrank();
    }
    

    function test_setRepaymentTime_FailWhenSenderIsNotOwner() public {
        vm.startPrank(alice);
    
        vm.expectRevert("you are not an owner");
        lendvestAjnaVault.setRepaymentTime(1);
    
        vm.stopPrank();
    }

    function test_start_epoch_FailWhenSenderIsNotOwner() public {
        vm.startPrank(alice);
    
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

    function test_endEpoch_FailWhenSenderIsNotOwner() public {
        vm.startPrank(alice);
    
        vm.expectRevert("you are not an owner");
        lendvestAjnaVault.end_epoch();
    
        vm.stopPrank();
    }

    function test_endEpoch_FailWhenTimeIsNotElapsed() public {
        vm.startPrank(address(lendvestAjnaVault.owner()));
    
        vm.expectRevert("time left in epoch ending");
        lendvestAjnaVault.end_epoch();
    
        vm.stopPrank();
    }

    function test_endEpoch_SuccessfulEndWhenTimeIsElapsed() public {
        vm.startPrank(address(lendvestAjnaVault.owner()));
    
        lendvestAjnaVault.start_epoch();
        vm.warp(block.timestamp + 86400 * 14 + 1);
        lendvestAjnaVault.end_epoch();
    
        assertEq(lendvestAjnaVault.epoch_started(), false);
    
        vm.stopPrank();
    }
}