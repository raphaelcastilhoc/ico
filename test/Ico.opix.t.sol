//SPDX-License-Identifier: Unlicense
pragma solidity 0.8.19;
import "forge-std/test.sol";
import "contracts/Ico.sol";


contract IcoTest is Test {

    address alice = address(0x456);
    address bob = address(0x789);
    address charlie = address(0xabc);
    address david = address(0xdef);
    address eve = address(0xff);
    address fred = address(0xaaa);
    address greg = address(0xbbb);
    address harry = address(0xccc);
    address isable = address(0xddd);
    address james = address(0xeee);   
    address carol = address(0x123);

    function test_advancePhase_PhaseAdvanceDuringSameBlock() public {
        
        // alice creates an ico, allowing herself and bob
        vm.startPrank(alice);
        address[] memory allowList = new address[](2);
        allowList[0] = alice;
        allowList[1] = bob;
        address treasury = address(0xdef);
        Ico ico = new Ico(allowList, treasury);

        ico.advancePhase("GENERAL");
        vm.expectRevert("Cannot advance phase more than once per block");
        ico.advancePhase("OPEN");
        vm.stopPrank();
    
    }

    function test_contribute_ContributeDuringOpenPhase() public {
        
        vm.startPrank(alice);
        address[] memory allowList = new address[](2);
        allowList[0] = alice;
        allowList[1] = bob;
        address treasury = address(0xdef);
        Ico ico = new Ico(allowList, treasury);
        ico.advancePhase("GENERAL");
        vm.roll(block.number + 1);
        ico.advancePhase("OPEN");
        vm.stopPrank();

        vm.deal(bob, 1000);
        vm.startPrank(bob);
        ico.contribute{value: 500}();
        vm.stopPrank();

    }

    function test_advancePhase_AdvancePhaseSeedToGeneral() public {
    
        vm.startPrank(alice);
        address[] memory allowList = new address[](3);
        allowList[0] = alice;
        allowList[1] = bob;
        address treasury = address(0xdef);
        Ico ico = new Ico(allowList, treasury);
        ico.advancePhase("GENERAL");
        assertEq(uint(ico.fundingPhase()), 1, "Funding phase should be GENERAL");
        vm.stopPrank();
    
    }

    function test_advancePhase_AdvancePhaseGeneralToOpen() public {
    
        // The error is due to the fact that the block number is not being advanced between the two calls to advancePhase. 
        // We can use the vm.roll cheatcode to advance the block number.
        
        vm.startPrank(alice);
        address[] memory allowList = new address[](2);
        allowList[0] = alice;
        allowList[1] = bob;
        address treasury = address(0xdef);
        Ico ico = new Ico(allowList, treasury);
        ico.advancePhase("GENERAL");
        vm.roll(block.number + 1); // Advance the block number
        ico.advancePhase("OPEN");
        assertEq(uint(ico.fundingPhase()), 2, "Funding phase should be OPEN");
    
    }

    function test_advancePhase_AdvancingPhaseFromNonSeedOrGeneral() public {
    
        // The test failed because the advancePhase function was called twice in the same block. 
        // We need to increment the block number between the two calls to advancePhase. 
        // We can use the vm.roll function to increment the block number.
        
        vm.startPrank(alice);
        address[] memory allowList = new address[](3);
        allowList[0] = alice;
        allowList[1] = bob;
        address treasury = address(0xdef);
        Ico ico = new Ico(allowList, treasury);
        ico.advancePhase("GENERAL");
        vm.roll(block.number + 1); // increment block number
        ico.advancePhase("OPEN");
        vm.roll(block.number + 1); // increment block number
        vm.expectRevert("Cannot advance phase");
        ico.advancePhase("OPEN");
        vm.stopPrank();
    
    }

    function test_advancePhase_NonOwnerAdvancingPhase() public {
    
         
        // alice creates an ico, allowing herself and bob
        vm.startPrank(alice);
        address[] memory allowList = new address[](2);
        allowList[0] = alice;
        allowList[1] = bob;
        address treasury = address(0xdef);
        Ico ico = new Ico(allowList, treasury);
        vm.stopPrank();
        
        // bob tries to advance the phase, which should fail because he is not the owner
        vm.startPrank(bob);
        vm.expectRevert("Only owner can call this function");
        ico.advancePhase("GENERAL");
        vm.stopPrank();
    
    }


    function test_redeem_RedeemTokensFullyRedeemed() public {
        
        vm.startPrank(alice);
        address[] memory allowList = new address[](2);
        allowList[0] = alice;
        allowList[1] = bob;
        address treasury = address(0xdef);
        Ico ico = new Ico(allowList, treasury);
        vm.stopPrank();
        vm.deal(bob, 10000);
       // bob contributes to the ico
        vm.startPrank(bob);
        ico.contribute{value: 1000}();
        vm.stopPrank();
        
        // check that bob's contribution is recorded correctly
        assertEq(ico.contributions(bob), 1000, "Bob's contribution should be 1000 ether");
        
        // bob redeems his contribution
        vm.startPrank(bob);
        ico.redeem();
        
        // check that bob's redemption is recorded correctly
        assertEq(ico.redeemed(bob), 5000, "Bob's redeemed amount should be 5000");

        // bob trie/Users/zacharywaxman/repos/allo-v2s to redeem again, but it should fail because he has already redeemed all of his contributions
        vm.expectRevert("No contributions to redeem");
        ico.redeem();
        vm.stopPrank();
        
    }

    function test_contribute_ContributionWhenAcceptingContributionsFalse() public {
    
        // alice creates an ico, allowing herself and bob, but toggles accepting contributions, so contributions should not be accepted
        vm.startPrank(alice);
        address[] memory allowList = new address[](2);
        allowList[0] = alice;
        allowList[1] = bob;
        address treasury = address(0xdef);
        Ico ico = new Ico(allowList, treasury);
        ico.toggleAcceptingContributions();
        vm.stopPrank();
        vm.deal(bob, 1000);
        vm.startPrank(bob);
        vm.expectRevert("Not accepting contributions");
        ico.contribute{value: 100 }();
    
    }

    function test_contribute_ContributionWhenFundingPhaseSeed() public {
    
        // alice creates an ico, allowing herself and bob to contribute
        vm.startPrank(alice);
        address[] memory allowList = new address[](2);
        allowList[0] = alice;
        allowList[1] = bob;
        address treasury = address(0xdef);
        Ico ico = new Ico(allowList, treasury);
        vm.stopPrank();
        
        // bob contributes to the ico
        vm.deal(bob, 1000);
        vm.startPrank(bob);
        ico.contribute{value: 100 }();
        vm.stopPrank();
        
        // check that bob's contribution was successful
        assertEq(ico.contributions(bob), 100, "Bob's contribution should be 100");
        assertEq(ico.totalContributions(), 100, "Total contributions should be 100");
    
    }

    function test_contribute_ContributionWhenFundingPhaseGeneral() public {
    
        // alice creates an ico, allowing herself and bob, and advances the phase to GENERAL
        vm.startPrank(alice);
        address[] memory allowList = new address[](2);
        allowList[0] = alice;
        allowList[1] = bob;
        address treasury = address(0xdef);
        Ico ico = new Ico(allowList, treasury);
        ico.advancePhase("GENERAL");
        vm.stopPrank();
        vm.deal(bob, 1000);
        vm.startPrank(bob);
        ico.contribute{value: 100 }();
        vm.stopPrank();
        assertEq(ico.contributions(bob), 100, "Bob should have contributed 100 wei");
        assertEq(ico.totalContributions(), 100, "Total contributions should be 100 wei");
    
    }

    function test_contribute_MockingContributeMethods() public {
         
        // alice creates an ico, allowing herself and bob, but toggles accepting contributions, so contributions should not be accepted
        vm.startPrank(alice);
        address[] memory allowList = new address[](2);
        allowList[0] = alice;
        allowList[1] = bob;
        address treasury = address(0xdef);
        Ico ico = new Ico(allowList, treasury);
        ico.toggleAcceptingContributions();
        vm.stopPrank();
        vm.deal(bob, 1000);
        vm.startPrank(bob);
        vm.expectRevert("Not accepting contributions");
        ico.contribute{value: 100 }();
    
    }

    function test_redeem_RedeemTokensWhenRedemptionsAreAcceptedAndSenderHasUnfreedContributions() public {
    
        // The mint function is not available in the SpaceCoin contract. 
        // However, the contract has a constructor that mints some tokens when it's deployed. 
        // We can use this to our advantage by deploying a new SpaceCoin contract with the desired amount of tokens.
        
        // alice creates an ico, allowing herself and bob
        vm.startPrank(alice);
        address[] memory allowList = new address[](2);
        allowList[0] = alice;
        allowList[1] = bob;
        address treasury = address(0xdef);
        Ico ico = new Ico(allowList, treasury);
        vm.stopPrank();
        
        // alice gives bob some ether
        vm.deal(bob, 1000);
        
        // bob contributes to the ico
        vm.startPrank(bob);
        ico.contribute{value: 1000}();
        vm.stopPrank();
        
        // check that bob's contribution is recorded correctly
        assertEq(ico.contributions(bob), 1000, "Bob's contribution should be 1000 ether");
        
        // bob redeems his contribution
        vm.startPrank(bob);
        ico.redeem();
        vm.stopPrank();
        
        // check that bob's redemption is recorded correctly
        assertEq(ico.redeemed(bob), 5000, "Bob's redeemed amount should be 5000");
    
    }

    function test_redeem_RedeemTokensWhenRedemptionsAreNotBeingAccepted() public {
    
        // Alice creates an ICO, allowing herself and Bob to contribute. She then toggles accepting redemptions, so redemptions should not be accepted.
        vm.startPrank(alice);
        address[] memory allowList = new address[](2);
        allowList[0] = alice;
        allowList[1] = bob;
        address treasury = address(0xdef);
        Ico ico = new Ico(allowList, treasury);
        ico.toggleAcceptingRedemptions();
        vm.stopPrank();
        
        // Bob tries to redeem his tokens, but the transaction should fail because redemptions are not being accepted.
        vm.startPrank(bob);
        vm.expectRevert("Not accepting redemptions");
        ico.redeem();
        vm.stopPrank();
    
    }

    function test_redeem_RedeemTokensWhenSendersContributionBalanceIsLessThanOrEqualToTheRedeemedBalance() public {
    
         
        // alice creates an ico, allowing herself and bob, but toggles accepting contributions, so contributions should not be accepted
        vm.startPrank(alice);
        address[] memory allowList = new address[](2);
        allowList[0] = alice;
        allowList[1] = bob;
        address treasury = address(0xdef);
        Ico ico = new Ico(allowList, treasury);
        ico.toggleAcceptingContributions();
        vm.stopPrank();
        vm.deal(bob, 1000);
        vm.startPrank(bob);
        vm.expectRevert("No contributions to redeem");
        ico.redeem();
        
    
    }

    function test_addressAllowed_IncludedAddressCheck() public {
    
         
        // alice creates an ico, allowing herself and bob
        vm.startPrank(alice);
        address[] memory allowList = new address[](2);
        allowList[0] = alice;
        allowList[1] = bob;
        address treasury = address(0xdef);
        Ico ico = new Ico(allowList, treasury);
        vm.stopPrank();
        
        // check if alice is allowed
        bool aliceAllowed = ico.addressAllowed(alice);
        assertEq(aliceAllowed, true, "Alice should be allowed");
        
        // check if bob is allowed
        bool bobAllowed = ico.addressAllowed(bob);
        assertEq(bobAllowed, true, "Bob should be allowed");
        
        // check if charlie is not allowed
        bool charlieAllowed = ico.addressAllowed(charlie);
        assertEq(charlieAllowed, false, "Charlie should not be allowed");
    
    }

    function test_addressAllowed_ExcludedAddressCheck() public {
    
         
        // alice creates an ico, allowing herself and bob
        vm.startPrank(alice);
        address[] memory allowList = new address[](2);
        allowList[0] = alice;
        allowList[1] = bob;
        address treasury = address(0xdef);
        Ico ico = new Ico(allowList, treasury);
        vm.stopPrank();
        
        // check if charlie is allowed to contribute
        bool isAllowed = ico.addressAllowed(charlie);
        assertEq(isAllowed, false, "Charlie should not be allowed to contribute");
    
    }

    function test_addressAllowed_CheckWithEmptyAllowList() public {
    
         
        // alice creates an ico with an empty allowList
        vm.startPrank(alice);
        address[] memory allowList = new address[](0);
        address treasury = address(0xdef);
        Ico ico = new Ico(allowList, treasury);
        vm.stopPrank();
        
        // check if bob is allowed
        bool isAllowed = ico.addressAllowed(bob);
        assertEq(isAllowed, false, "Bob should not be allowed as the allowList is empty");
    
    }

    function test_toggleAcceptingContributions_ToggleAcceptingContributionsOwnerTrueToFalse() public {
    
        // alice creates an ico, allowing herself and bob, and then toggles accepting contributions, so contributions should not be accepted
        vm.startPrank(alice);
        address[] memory allowList = new address[](2);
        allowList[0] = alice;
        allowList[1] = bob;
        address treasury = address(0xdef);
        Ico ico = new Ico(allowList, treasury);
        ico.toggleAcceptingContributions();
        vm.stopPrank();
        assertEq(ico.acceptingContributions(), false, "Contributions should not be accepted");
    
    }

    function test_toggleAcceptingContributions_ToggleAcceptingContributionsOwnerFalseToTrue() public {
    
        // alice creates an ico, allowing herself and bob, but toggles accepting contributions, so contributions should not be accepted
        vm.startPrank(alice);
        address[] memory allowList = new address[](2);
        allowList[0] = alice;
        allowList[1] = bob;
        address treasury = address(0xdef);
        Ico ico = new Ico(allowList, treasury);
        ico.toggleAcceptingContributions();
        vm.stopPrank();
        
        // Check that acceptingContributions is now false
        assertEq(ico.acceptingContributions(), false, "Contributions should not be accepted");
        
        // Alice toggles accepting contributions again, so contributions should now be accepted
        vm.startPrank(alice);
        ico.toggleAcceptingContributions();
        vm.stopPrank();
        
        // Check that acceptingContributions is now true
        assertEq(ico.acceptingContributions(), true, "Contributions should be accepted");
    
    }

    function test_toggleAcceptingContributions_NonOwnerToggleAcceptingContributions() public {
    
        // alice creates an ico, allowing herself and bob
        vm.startPrank(alice);
        address[] memory allowList = new address[](2);
        allowList[0] = alice;
        allowList[1] = bob;
        address treasury = address(0xdef);
        Ico ico = new Ico(allowList, treasury);
        vm.stopPrank();
        
        // bob tries to toggle accepting contributions, but he is not the owner, so it should revert
        vm.startPrank(bob);
        vm.expectRevert("Only owner can call this function");
        ico.toggleAcceptingContributions();
        vm.stopPrank();
        
        // check that accepting contributions is still true
        assertEq(ico.acceptingContributions(), true, "Accepting contributions should still be true");
    
    }

    function test_toggleAcceptingRedemptions_ToggleAcceptingRedemptionsByOwnerInitialStateTrue() public {
    
         
        // alice creates an ico, allowing herself and bob, and toggles accepting redemptions, so redemptions should not be accepted
        vm.startPrank(alice);
        address[] memory allowList = new address[](2);
        allowList[0] = alice;
        allowList[1] = bob;
        address treasury = address(0xdef);
        Ico ico = new Ico(allowList, treasury);
        ico.toggleAcceptingRedemptions();
        vm.stopPrank();
        assertEq(ico.acceptingRedemptions(), false, "Redemptions should not be accepted");
    
    }

    function test_toggleAcceptingRedemptions_ToggleAcceptingRedemptionsByOwnerInitialStateFalse() public {
    
        // alice creates an ico, allowing herself and bob, but toggles accepting redemptions, so redemptions should not be accepted
        vm.startPrank(alice);
        address[] memory allowList = new address[](2);
        allowList[0] = alice;
        allowList[1] = bob;
        address treasury = address(0xdef);
        Ico ico = new Ico(allowList, treasury);
        ico.toggleAcceptingRedemptions();
        vm.stopPrank();
        // check that acceptingRedemptions is now false
        assertEq(ico.acceptingRedemptions(), false, "Redemptions should not be accepted");
        // alice toggles accepting redemptions again, so redemptions should now be accepted
        vm.startPrank(alice);
        ico.toggleAcceptingRedemptions();
        vm.stopPrank();
        // check that acceptingRedemptions is now true
        assertEq(ico.acceptingRedemptions(), true, "Redemptions should be accepted");
    }
}
