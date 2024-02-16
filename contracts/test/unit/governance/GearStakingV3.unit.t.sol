// SPDX-License-Identifier: UNLICENSED
// Gearbox Protocol. Generalized leverage for DeFi protocols
// (c) Gearbox Foundation, 2023.
pragma solidity ^0.8.17;

import "./OlympixUnitTest.sol";

import {GearStakingV3, EPOCH_LENGTH} from "../../../governance/GearStakingV3.sol";
import {IGearStakingV3Events, MultiVote, VotingContractStatus} from "../../../interfaces/IGearStakingV3.sol";
import {IVotingContractV3} from "../../../interfaces/IVotingContractV3.sol";

import "../../../interfaces/IAddressProviderV3.sol";
import {IERC20Permit} from "@openzeppelin/contracts/token/ERC20/extensions/IERC20Permit.sol";

// TEST
import "../../lib/constants.sol";

// MOCKS
import {AddressProviderV3ACLMock} from "../../mocks/core/AddressProviderV3ACLMock.sol";

import {TargetContractMock} from "../../mocks/core/TargetContractMock.sol";

// SUITES
import {TokensTestSuite} from "../../suites/TokensTestSuite.sol";
import {Tokens} from "@gearbox-protocol/sdk-gov/contracts/Tokens.sol";

// EXCEPTIONS
import "../../../interfaces/IExceptions.sol";

contract GearStakingV3UnitTest is OlympixUnitTest("GearStakingV3"), IGearStakingV3Events {
    address gearToken;

    AddressProviderV3ACLMock public addressProvider;

    GearStakingV3 gearStaking;

    TargetContractMock votingContract;

    TokensTestSuite tokenTestSuite;

    function setUp() public {
        vm.prank(CONFIGURATOR);
        addressProvider = new AddressProviderV3ACLMock();

        tokenTestSuite = new TokensTestSuite();

        gearToken = tokenTestSuite.addressOf(Tokens.WETH);

        vm.prank(CONFIGURATOR);
        addressProvider.setAddress(AP_GEAR_TOKEN, gearToken, false);

        gearStaking = new GearStakingV3(address(addressProvider), block.timestamp + 1);

        votingContract = new TargetContractMock();

        vm.prank(CONFIGURATOR);
        gearStaking.setVotingContractStatus(address(votingContract), VotingContractStatus.ALLOWED);
    }

    function test_claimWithdrawals_SuccessfulClaimWithdrawalsWhenConditionIsTrue() public {
    gearStaking.claimWithdrawals(address(this));
}

    function test_multivote_SuccessfulMultivoteWhenVotesLengthIsZero() public {
    MultiVote[] memory votes = new MultiVote[](0);
    gearStaking.multivote(votes);
}

    function test_getCurrentEpoch_FailWhenTimestampIsLessThanFirstEpochTimestamp() public {
    uint16 expectedEpoch = 0;
    uint16 currentEpoch = gearStaking.getCurrentEpoch();
    assertEq(currentEpoch, expectedEpoch);
}

    function test_balanceOf_SuccessfulBalanceOf() public {
    address user = address(this);
    uint256 expectedTotalStaked = 0;
    uint256 totalStaked = gearStaking.balanceOf(user);
    assertEq(totalStaked, expectedTotalStaked);
}

    function test_availableBalance_SuccessfulAvailableBalance() public {
    address user = address(this);
    uint256 expectedAvailableBalance = 0;
    uint256 availableBalance = gearStaking.availableBalance(user);
    assertEq(availableBalance, expectedAvailableBalance);
}

    function test_setMigrator_SuccessfulSetMigratorWhenMigratorIsEqualToNewMigrator() public {
    vm.prank(CONFIGURATOR);
    gearStaking.setMigrator(address(0));
    vm.prank(CONFIGURATOR);
    gearStaking.setMigrator(address(0));
    assert(gearStaking.migrator() == address(0));
}
}