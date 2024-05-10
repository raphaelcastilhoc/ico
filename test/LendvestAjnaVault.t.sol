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
    

    function test_LendQuoteToken_SuccessfulLend() public {
        vm.startPrank(user);
    
        deal(lendvestAjnaVault.weth(), user, 100 ether);
    
        ERC20(lendvestAjnaVault.weth()).approve(address(lendvestAjnaVault), 100 ether);
    
        lendvestAjnaVault.LendQuoteToken(1 ether);
    
        assertEq(lendvestAjnaVault.SupplierToAmount(user), 1 ether);
        assertEq(lendvestAjnaVault.totalAmountOfQuoteToken(), 1 ether);
        assertEq(ERC20(lendvestAjnaVault.weth()).balanceOf(user), 99 ether);
    
        vm.stopPrank();
    }

    function test_withdrawQuoteToken_FailWithdrawWhenBalanceIsInsufficient() public {
        vm.startPrank(user);
    
        vm.expectRevert("not have enough Quote Token");
        lendvestAjnaVault.withdrawQuoteToken(1);
    
        vm.stopPrank();
    }

    function test_withdrawColletralofLiquidation_FailWithdrawWhenBalanceIsInsufficient() public {
        vm.startPrank(user);
    
        vm.expectRevert("not have enough colletral");
        lendvestAjnaVault.withdrawColletralofLiquidation(1);
    
        vm.stopPrank();
    }

    function test_quoteTokenAddress_SuccessfulGet() public {
        address quoteTokenAddress = lendvestAjnaVault.quoteTokenAddress();
    //    assertEq(quoteTokenAddress, address(0xEE516644509709A64906Bb1574930cdAE8659801));
    }
    

    function test_getPoolAddress_SuccessfulGet() public {
        assertEq(lendvestAjnaVault.getPoolAddress(), address(lendvestAjnaVault.pool()));
    }

    function test_setRepaymentTime_FailWhenSenderIsNotOwner() public {
        vm.startPrank(user);
    
        vm.expectRevert("you are not an owner");
        lendvestAjnaVault.setRepaymentTime(1);
    
        vm.stopPrank();
    }

    function test_amountEarnedByLender_SuccessfulCalculation() public {
        vm.startPrank(user);
    
        deal(lendvestAjnaVault.weth(), user, 100 ether);
        ERC20(lendvestAjnaVault.weth()).approve(address(lendvestAjnaVault), 100 ether);
        lendvestAjnaVault.LendQuoteToken(1 ether);
    
        uint256 amountEarned = lendvestAjnaVault.amountEarnedByLender(user);
    
        assertEq(amountEarned, 0);
    
        vm.stopPrank();
    }

    function test_start_epoch_FailWhenSenderIsNotOwner() public {
        vm.startPrank(user);
    
        vm.expectRevert("you are not an owner");
        lendvestAjnaVault.start_epoch();
    
        vm.stopPrank();
    }

    function test_endEpoch_FailWhenSenderIsNotOwner() public {
        vm.startPrank(user);
    
        vm.expectRevert("you are not an owner");
        lendvestAjnaVault.end_epoch();
    
        vm.stopPrank();
    }
}