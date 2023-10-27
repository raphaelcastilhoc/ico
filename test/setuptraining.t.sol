// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;
import "forge-std/test.sol";
import "contracts/Ico.sol";


contract IcoTest is Test {


    // EOAs
    address icoCreator = address(0x2);
    address treasury = address(0x123);
    address allowed_one = address(0x456);
    address allowed_two = address(0x789);
    address unallowed_one = address(0xabc);

    
    // Contracts
    Ico ico;
    SpaceCoin spaceCoin;

    function setUp() public {
        
        vm.deal(allowed_one, 100 ether);
        vm.deal(allowed_two, 100 ether);
        vm.deal(unallowed_one, 100 ether);

        address[] memory allowList = new address[](2);
        allowList[0] = allowed_one;
        allowList[1] = allowed_two;
        vm.startPrank(icoCreator);
        ico = new Ico(allowList, treasury);
        spaceCoin = ico.token();
        vm.stopPrank();
    }


    function test_Ico_advancePhase_AdvanceToGeneral() public {
        vm.startPrank(icoCreator);
        ico.advancePhase("GENERAL");
        vm.stopPrank();
    }

    function test_Ico_advancePhase_AdvanceToOpen() public {
        vm.startPrank(icoCreator);
        ico.advancePhase("GENERAL");
        vm.roll(block.number + 1);
        ico.advancePhase("OPEN");
        vm.stopPrank();
    }

    function test_Ico_advancePhase_RevertIfCannotAdvance() public {
        vm.startPrank(icoCreator);
        ico.advancePhase("GENERAL");
        vm.roll(block.number + 1);
        ico.advancePhase("OPEN");
        vm.roll(block.number + 1);
        vm.expectRevert("Cannot advance phase");
        ico.advancePhase("OPEN");
        vm.stopPrank();
    }

    function test_Ico_contribute_NotAcceptingContributions() public {
        vm.startPrank(icoCreator);
        ico.toggleAcceptingContributions();
        vm.stopPrank();

        vm.startPrank(allowed_one);
        // Because the addresses are not any ether in the setUp, we must give them here. It would be better if they were dealt in the setup
        vm.deal(allowed_one, 100 ether);
        vm.expectRevert("Not accepting contributions");
        ico.contribute{value: 1 ether}();
    }

    function test_Ico_contribute_DuringSeed() public {
        vm.startPrank(allowed_one);
        // Because the addresses are not any ether in the setUp, we must give them here. It would be better if they were dealt in the setup
        vm.deal(allowed_one, 100 ether);
        ico.contribute{value: 1 ether}();
    }

    function test_Ico_contribute_DuringGeneral() public {
        vm.startPrank(icoCreator);
        ico.advancePhase("GENERAL");
        vm.stopPrank();

        vm.startPrank(allowed_one);
        // Because the addresses are not any ether in the setUp, we must give them here. It would be better if they were dealt in the setup
        vm.deal(allowed_one, 100 ether);
        ico.contribute{value: 1 ether}();
    }

    function test_Ico_contribute_DuringOpen() public {
        
        vm.startPrank(icoCreator);
        ico.advancePhase("GENERAL");
        vm.roll(block.number + 1);
        ico.advancePhase("OPEN");
        vm.stopPrank();

        vm.startPrank(allowed_one);
        // Because the addresses are not any ether in the setUp, we must give them here. It would be better if they were dealt in the setup
        vm.deal(allowed_one, 100 ether);
        ico.contribute{value: 1 ether}();
    }

    function test_Ico_redeem_Success() public {
        vm.startPrank(allowed_one);
        // Because the addresses are not any ether in the setUp, we must give them here. It would be better if they were dealt in the setup
        ico.contribute{value: 1 }();
        
        ico.redeem();
        vm.stopPrank();
    }
}
