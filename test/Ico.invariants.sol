//SPDX-License-Identifier: Unlicense
pragma solidity 0.8.19;
import "forge-std/test.sol";
import "contracts/Ico.sol";
import {StdInvariant} from "forge-std/StdInvariant.sol";

contract IcoInvariants is StdInvariant, Test {

    address alice = address(0x456);
    address bob = address(0x789);
    address charlie = address(0xabc);
    address david = address(0xdef);
    address eve = address(0xff);
    address fred = address(0xaaa);
    address greg = address(0xbbb);
    Ico ico;

    function setUp() public {
        vm.startPrank(alice);
        address[] memory allowList = new address[](2);
        allowList[0] = alice;
        allowList[1] = bob;
        address treasury = address(0xdef);
        ico = new Ico(allowList, treasury);
        targetContract(address(ico));
    }

    function invariant_OwnerDoesNotChange() public view {
        assert(ico.owner() == alice);
    }

    function invariant_ValidFundingPhase() public view {
        assert(ico.fundingPhase() == FundingPhase.SEED || ico.fundingPhase() == FundingPhase.GENERAL || ico.fundingPhase() == FundingPhase.OPEN);        
    }

    function invariant_RedeemdLessThanContributed() public {
        assert(ico.redeemed(msg.sender) <= ico.contributions(msg.sender));
    }
}