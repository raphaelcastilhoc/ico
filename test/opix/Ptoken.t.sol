// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
import "lib/forge-std/src/Test.sol";
import "contracts/PToken.sol";
import "contracts/test/TestERC20.sol";


abstract contract OlympixUnitTest is Test {
    constructor(string memory name_) {}
}



contract PtokenTest is OlympixUnitTest("PToken") {
    
    PToken ptoken;
    address euler = address(0x2);
    address underlying;

    function setUp() public {
        underlying = address(new TestERC20("Test", "TEST", 8, false));
        ptoken = new PToken(euler, underlying);
    }

    /**
* The problem with my previous attempt was that I was trying to compare two strings using the '==' operator, which is not allowed in Solidity. I should have used the 'keccak256' function to hash both strings and then compare the hashes.
*/
function test_name_SuccessfulName() public {
    string memory name = ptoken.name();
    assert(keccak256(bytes(name)) == keccak256(bytes(string(abi.encodePacked("Euler Protected ", TestERC20(underlying).name())))));
}

    function test_symbol_SuccessfulSymbol() public {
    string memory symbol = ptoken.symbol();
    assert(keccak256(abi.encodePacked(symbol)) == keccak256(abi.encodePacked("pTEST")));
}

    function test_decimals_SuccessfulDecimals() public {
    vm.prank(underlying);
    ptoken.decimals();
}

    function test_underlying_SuccessfulUnderlying() public {
    assert(ptoken.underlying() == underlying);
}

    function test_allowance_SuccessfulAllowance() public {
    ptoken.approve(address(0x1), 10);
    assert(ptoken.allowance(address(this), address(0x1)) == 10);
}

    function test_transfer_SuccessfulTransfer() public {
    TestERC20(underlying).mint(address(this), 10);
    TestERC20(underlying).approve(address(ptoken), 10);
    ptoken.wrap(10);
    ptoken.transfer(address(0x1), 1);
    assert(ptoken.balanceOf(address(this)) == 9);
    assert(ptoken.balanceOf(address(0x1)) == 1);
}

    function test_transferFrom_FailWhenSenderBalanceIsLessThanAmount() public {
    vm.expectRevert("insufficient balance");
    ptoken.transferFrom(address(this), address(0x1), 1);
}

    /**
* The problem with my previous attempt was that I didn't approve the ptoken contract to spend the test contract's tokens before wrapping them into the ptoken contract. Therefore, the wrapping operation failed because the ptoken contract didn't have the allowance to transfer the test contract's tokens.
*/
function test_transferFrom_SuccessfulTransferFromSenderToRecipient() public {
    TestERC20(underlying).mint(address(this), 10);
    TestERC20(underlying).approve(address(ptoken), 10);
    ptoken.wrap(10);
    ptoken.transferFrom(address(this), address(0x1), 1);
    assert(ptoken.balanceOf(address(this)) == 9);
    assert(ptoken.balanceOf(address(0x1)) == 1);
}

    function test_transferFrom_FailWhenSenderAllowanceIsLessThanAmount() public {
    TestERC20(underlying).mint(address(this), 10);
    TestERC20(underlying).approve(address(ptoken), 10);
    ptoken.wrap(10);
    ptoken.approve(address(0x1), 1);
    vm.prank(address(0x1));
    vm.expectRevert("insufficient allowance");
    ptoken.transferFrom(address(this), address(0x2), 2);
}

    function test_forceUnwrap_FailWhenSenderIsNotEuler() public {
    vm.expectRevert("permission denied");
    ptoken.forceUnwrap(address(this), 0);
}

    function test_forceUnwrap_SuccessfulForceUnwrap() public {
    vm.prank(euler);
    ptoken.forceUnwrap(address(this), 0);
}

    function test_claimSurplus_FailWhenThereIsNoSurplusBalanceToClaim() public {
    vm.expectRevert("no surplus balance to claim");
    ptoken.claimSurplus(address(this));
}

    function test_claimSurplus_SuccessfulClaimSurplus() public {
    TestERC20(underlying).mint(address(ptoken), 10);
    ptoken.claimSurplus(address(this));
    assertEq(ptoken.balanceOf(address(this)), 10);
    assertEq(ptoken.totalSupply(), 10);
}

    function test_doUnwrap_FailWhenSenderBalanceIsLessThanAmount() public {
    vm.expectRevert("insufficient balance");
    ptoken.unwrap(1);
}
}