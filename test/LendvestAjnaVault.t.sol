// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.18;

import "forge-std/Test.sol";
import "contracts/LendvestAjnaVault.sol";
import "test/OlympixUnitTest.sol";

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

    

    function test_withdrawQuoteToken_FailWhenSenderDoesNotHaveEnoughQuoteToken() public {
            vm.expectRevert("not have enough Quote Token");
            lendvestAjnaVault.withdrawQuoteToken(1);
        }

    function test_withdrawColletralofLiquidation_FailWhenSenderDoesNotHaveEnoughColletral() public {
            vm.expectRevert("not have enough colletral");
            lendvestAjnaVault.withdrawColletralofLiquidation(1);
        }

    function test_getPoolAddress_SuccessfulGetPoolAddress() public {
        address poolAddress = lendvestAjnaVault.getPoolAddress();
        assertTrue(poolAddress != address(0));
    }

    function test_balanceOfColletralNotUsed_SuccessfulBalanceOfColletralNotUsed() public {
        uint256 balance = lendvestAjnaVault.balanceOfColletralNotUsed(address(this));
        assertEq(balance, 0);
    }
}