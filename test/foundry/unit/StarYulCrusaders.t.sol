// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import {Test} from "forge-std/Test.sol";
import {StarYulCrusaders} from "../../../contracts/StarYulCrusaders.sol";

// import {OlympixUnitTest} from "./OlympixUnitTest.t.sol";

abstract contract OlympixUnitTest is Test {
    constructor(string memory targetName) {}
}

contract StarYulCrusadersTest is OlympixUnitTest("StarYulCrusaders") {
    StarYulCrusaders target;
    address player;

    function setUp() public {
        target = new StarYulCrusaders();
        player = vm.addr(1);
        vm.deal(player, 14 ether);
        vm.startPrank(player);
    }

    function test_explorePlanet_SuccessfulExplore() public {
        uint256 planetId = 1;
        uint256 expectedStardustPoints = planetId % 5 + 1;
    
        target.explorePlanet{value: 1 ether}(planetId);
    
        uint256 stardustPoints = target.stardustPoints(player);
        assertEq(stardustPoints, expectedStardustPoints);
    }

    /**
    * The problem with my previous attempt was that I didn't consider the penalty for non-alliance members when spending stardust. If a user is not part of an alliance, an additional stardust point is deducted from their balance. In my previous test, the player was not part of an alliance, so when they spent 1 stardust point, an additional point was deducted as a penalty, resulting in a stardust balance of 0, not 1 as I had asserted.
    */
    function test_spendStardust_SuccessfulSpend() public {
        target.explorePlanet{value: 1 ether}(1);
        uint256 amountToSpend = 1;
        target.spendStardust(amountToSpend);
        uint256 expectedStardustBalance = 0;
        assertEq(target.getStardustBalance(), expectedStardustBalance);
    }

    function test_createAlliance_SuccessfulCreation() public {
        string memory name = "Alliance1";
        target.createAlliance{value: 10 ether}(name);
        vm.stopPrank();
        string memory allianceName = target.getAllianceName(1);
        assert(keccak256(abi.encodePacked((allianceName))) == keccak256(abi.encodePacked((name))));
    }

    /**
    * The problem with my previous attempt was that I didn't have enough ether in the player's account to cover the cost of creating an alliance and joining an alliance. Each of these operations requires 10 ether, so I needed at least 20 ether in the player's account. In my previous test, I only had 14 ether in the player's account, which is why the test failed with an OutOfFunds error.
    */
    function test_joinAlliance_SuccessfulJoin() public {
        vm.deal(player, 20 ether);
        uint256 id = 1;
        string memory name = "Alliance1";
        target.createAlliance{value: 10 ether}(name);
        target.joinAlliance{value: 10 ether}(id);
        uint256 allianceId = target.alliances(player);
        assertEq(allianceId, id);
    }
}