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
    address public owner = address(123);
    address public alice = address(456);
    address public bob = address(789);

    function setUp() public {
        vm.createSelectFork("https://polygon-mainnet.g.alchemy.com/v2/aL2TEb50AXJcUeBihQls4qFrc828K-EL");

        vm.deal(owner, 100 ether);
        vm.deal(alice, 100 ether);
        vm.deal(bob, 100 ether);

        // simpleStorageInstance = new SimpleStorage();
        lendvestAjnaVault = new LendvestAjnaVault(0xEE516644509709A64906Bb1574930cdAE8659801,owner);

        deal(address(lendvestAjnaVault.weth()), alice, 100 ether);
        deal(address(lendvestAjnaVault.weth()), bob, 100 ether);
        
        // writeTokenBalance(address(this), address(lendvestAjnaVault.weth()), 1000 ether);
        // assertEq(ERC20(address(lendvestAjnaVault.weth())).balanceOf(address(this)),1000 ether); // approving the Ajna pool to take the colletral token
        
        // deal(address(lendvestAjnaVault.weth()), address(this), 100 ether);
        // assertEq(ERC20(address(lendvestAjnaVault.weth())).balanceOf(address(this)),100 ether); // approving the Ajna pool to take the colletral token
    }

    

    function test_LendQuoteToken_FailWhenEpochIsStarted() public {
        vm.startPrank(owner);
        lendvestAjnaVault.start_epoch();
        vm.stopPrank();
    
        vm.startPrank(alice);
    
        vm.expectRevert("epoch started");
        lendvestAjnaVault.LendQuoteToken(1 ether);
    
        vm.stopPrank();
    }

    function test_withdrawQuoteToken_FailWithdrawWhenBalanceIsInsufficient() public {
        vm.startPrank(alice);
    
        vm.expectRevert("not have enough Quote Token");
        lendvestAjnaVault.withdrawQuoteToken(1);
    
        vm.stopPrank();
    }

    function test_withdrawColletralofLiquidation_FailWithdrawWhenBalanceIsInsufficient() public {
        vm.startPrank(bob);
    
        vm.expectRevert("not have enough colletral");
        lendvestAjnaVault.withdrawColletralofLiquidation(1);
    
        vm.stopPrank();
    }

    function test_quoteTokenAddress_SuccessfulGet() public {
        vm.startPrank(alice);
    
        address quoteTokenAddress = lendvestAjnaVault.quoteTokenAddress();
    
        assertEq(quoteTokenAddress, address(lendvestAjnaVault.pool().quoteTokenAddress()));
    
        vm.stopPrank();
    }

    function test_getPoolAddress_SuccessfulGet() public {
        assertEq(lendvestAjnaVault.getPoolAddress(), address(0xEE516644509709A64906Bb1574930cdAE8659801));
    }

    function test_getCollateralAddress_SuccessfulGet() public {
        vm.startPrank(alice);
    
        address collateralAddress = lendvestAjnaVault.getCollateralAddress();
    
        assertEq(collateralAddress, address(lendvestAjnaVault.pool().collateralAddress()));
    
        vm.stopPrank();
    }

    function test_setRepaymentTime_FailWhenSenderIsNotOwner() public {
        vm.startPrank(alice);
    
        vm.expectRevert("you are not an owner");
        lendvestAjnaVault.setRepaymentTime(1);
    
        vm.stopPrank();
    }

    function test_setRepaymentTime_SuccessfulSet() public {
        vm.startPrank(owner);
    
        lendvestAjnaVault.setRepaymentTime(1);
    
        assertEq(lendvestAjnaVault.TIME_TO_REPAY(), 86400);
        
        vm.stopPrank();
    }

    function test_start_epoch_FailWhenSenderIsNotOwner() public {
        vm.startPrank(alice);
    
        vm.expectRevert("you are not an owner");
        lendvestAjnaVault.start_epoch();
    
        vm.stopPrank();
    }

    function test_start_epoch_FailWhenEpochAlreadyStarted() public {
        vm.startPrank(owner);
    
        lendvestAjnaVault.start_epoch();
    
        vm.expectRevert("already started");
        lendvestAjnaVault.start_epoch();
    
        vm.stopPrank();
    }

    function test_end_epoch_FailWhenSenderIsNotOwner() public {
        vm.startPrank(alice);
    
        vm.expectRevert("you are not an owner");
        lendvestAjnaVault.end_epoch();
    
        vm.stopPrank();
    }

    function test_end_epoch_FailWhenEpochIsNotOver() public {
        vm.startPrank(owner);
    
        lendvestAjnaVault.start_epoch();
    
        vm.expectRevert("time left in epoch ending");
        lendvestAjnaVault.end_epoch();
    
        vm.stopPrank();
    }
}