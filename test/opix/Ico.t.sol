//SPDX-License-Identifier: Unlicense
pragma solidity 0.8.19;
import "forge-std/test.sol";
import "contracts/Ico.sol";
import {StdInvariant} from "forge-std/StdInvariant.sol";

contract IcoTest is  StdInvariant, Test {

    address allowedOne = address(0x456);
    address allowedTwo = address(0x789);
    address notAllowedOne = address(0xabc);
    address notAllowedTwo = address(0xff);

    address icoCreator = address(0xdef);
    address treasury = address(0x123);

    Ico ico;
    SpaceCoin token;

    // vm.warp is used to change block.timestamp
    // vm.roll is used to change block.number -- example vm.roll(block.number + 1)

    function setUp() public {


        // dont use ether as a unit, just use numbers 
        vm.deal(icoCreator, 1000);
        vm.deal(allowedOne, 1000);
        vm.deal(allowedTwo, 1000);
        vm.deal(notAllowedOne, 1000);
        vm.deal(notAllowedTwo, 1000);

        vm.startPrank(icoCreator);
        address[] memory allowList = new address[](2);
        allowList[0] = allowedOne;
        allowList[1] = allowedTwo;
        ico = new Ico(allowList, treasury);
        token = ico.token();
        vm.stopPrank();


        targetContract(address(ico));
    }


    function invariant_RedemptionsDontExceedContributions() public view {
        assert(ico.redeemed(msg.sender) <= ico.contributions(msg.sender) * 5);

    }

    /* TEST_FUNCTIONS_HERE */
}