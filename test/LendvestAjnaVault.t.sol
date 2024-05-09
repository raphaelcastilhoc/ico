// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.18;

import "forge-std/Test.sol";
import "contracts/LendvestAjnaVault.sol";

// interface IERC20 {
//     function balanceOf(address) external view returns (uint256);
// }

abstract contract OlympixUnitTest is Test {
    constructor(string memory name_) {}
}
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

    address user = makeAddr("user");

    function setUp() public {

        vm.createSelectFork("https://polygon-mainnet.g.alchemy.com/v2/aL2TEb50AXJcUeBihQls4qFrc828K-EL");
        // simpleStorageInstance = new SimpleStorage();
        lendvestAjnaVault = new LendvestAjnaVault(0xEE516644509709A64906Bb1574930cdAE8659801,msg.sender);
        
        // writeTokenBalance(address(this), address(lendvestAjnaVault.weth()), 1000 ether);
        // assertEq(ERC20(address(lendvestAjnaVault.weth())).balanceOf(address(this)),1000 ether); // approving the Ajna pool to take the colletral token
        
        // deal(address(lendvestAjnaVault.weth()), address(this), 100 ether);
        // assertEq(ERC20(address(lendvestAjnaVault.weth())).balanceOf(address(this)),100 ether); // approving the Ajna pool to take the colletral token
        deal(lendvestAjnaVault.weth(), user, 100 ether);
    }

    function testDepositColletralForLiquidationSuccess() public {
        //Start value?

        //NEED TO MINT stakedETH or emulate wallet with tokens
        //???

        //User approves what token stakedETH?

        deal(address(lendvestAjnaVault.getCollateralAddress()), msg.sender, 100 ether);
        assertEq(ERC20(address(lendvestAjnaVault.getCollateralAddress())).balanceOf(msg.sender), 100 ether); // approving the Ajna pool to take the colletral token

        deal(address(lendvestAjnaVault.getCollateralAddress()), address(this), 100 ether);
        assertEq(ERC20(address(lendvestAjnaVault.getCollateralAddress())).balanceOf(address(this)), 100 ether); // approving the Ajna pool to take the colletral token
        ERC20(lendvestAjnaVault.getCollateralAddress()).transfer(msg.sender, 10 ether); // approving the Ajna pool to take the quote (WETH) token

        assertEq(ERC20(address(lendvestAjnaVault.getCollateralAddress())).balanceOf(address(this)), 90 ether); // approving the Ajna pool to take the colletral token
        assertEq(ERC20(address(lendvestAjnaVault.getCollateralAddress())).balanceOf(msg.sender), 110 ether); // approving the Ajna pool to take the colletral token

        ERC20(lendvestAjnaVault.getCollateralAddress()).approve(address(lendvestAjnaVault), 1); // approving the Ajna pool to take the colletral token
       
        assertEq(ERC20(lendvestAjnaVault.getCollateralAddress()).allowance(address(this),address(lendvestAjnaVault)) ,1);


        lendvestAjnaVault.depositColletralForLiquidation(1);
       
        //End value?
    }
    

    function test_LendQuoteToken_SuccessfulLendQuoteToken() public {
        vm.startPrank(user);
    
        ERC20(lendvestAjnaVault.weth()).approve(address(lendvestAjnaVault), 1);
        lendvestAjnaVault.LendQuoteToken(1);
    
        vm.stopPrank();
    
        assertEq(lendvestAjnaVault.SupplierToAmount(user), 1);
        assertEq(lendvestAjnaVault.totalAmountOfQuoteToken(), 1);
    }

    function test_withdrawQuoteToken_FailWhenBalanceIsInsufficient() public {
        vm.startPrank(user);
    
        vm.expectRevert("not have enough Quote Token");
        lendvestAjnaVault.withdrawQuoteToken(1);
    
        vm.stopPrank();
    }

    function test_withdrawColletralofLiquidation_FailWhenSenderDoesNotHaveEnoughColletral() public {
        vm.startPrank(user);
    
        vm.expectRevert("not have enough colletral");
        lendvestAjnaVault.withdrawColletralofLiquidation(1);
    
        vm.stopPrank();
    }

    function test_setRepaymentTime_FailWhenSenderIsNotOwner() public {
        vm.startPrank(user);
    
        vm.expectRevert("you are not an owner");
        lendvestAjnaVault.setRepaymentTime(1);
    
        vm.stopPrank();
    }

    function test_start_epoch_FailWhenSenderIsNotOwner() public {
        vm.startPrank(user);
    
        vm.expectRevert("you are not an owner");
        lendvestAjnaVault.start_epoch();
    
        vm.stopPrank();
    }

    function test_start_epoch_FailWhenEpochIsAlreadyStarted() public {
        vm.startPrank(address(lendvestAjnaVault.owner()));
    
        lendvestAjnaVault.start_epoch();
    
        vm.expectRevert("already started");
        lendvestAjnaVault.start_epoch();
    
        vm.stopPrank();
    }

    function test_endEpoch_FailWhenSenderIsNotOwner() public {
        vm.startPrank(user);
    
        vm.expectRevert("you are not an owner");
        lendvestAjnaVault.end_epoch();
    
        vm.stopPrank();
    }

    function test_endEpoch_SuccessfulEndEpoch() public {
        vm.startPrank(address(lendvestAjnaVault.owner()));
    
        lendvestAjnaVault.start_epoch();
    
        uint256 futureTimestamp = uint48(block.timestamp) + 15 days;
        vm.warp(futureTimestamp);
    
        lendvestAjnaVault.end_epoch();
    
        vm.stopPrank();
    
        assertEq(lendvestAjnaVault.epoch_started(), false);
    }

    function test_endEpoch_FailWhenEpochIsNotFinished() public {
        vm.startPrank(address(lendvestAjnaVault.owner()));
    
        lendvestAjnaVault.start_epoch();
    
        vm.expectRevert("time left in epoch ending");
        lendvestAjnaVault.end_epoch();
    
        vm.stopPrank();
    }
}