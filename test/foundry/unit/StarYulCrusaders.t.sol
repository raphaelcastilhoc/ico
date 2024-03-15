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

    function test_spendStardust_SuccessfulSpend() public {
        target.explorePlanet{value: 1 ether}(1);
        uint256 initialStardustBalance = target.getStardustBalance();
        target.spendStardust(1);
        uint256 finalStardustBalance = target.getStardustBalance();
        assertEq(finalStardustBalance, initialStardustBalance - 2);
    }

    function test_createAlliance_SuccessfulCreation() public {
        string memory name = "Alliance1";
        target.createAlliance{value: 10 ether}(name);
        vm.stopPrank();
        string memory allianceName = target.getAllianceName(1);
        assert(keccak256(abi.encodePacked((allianceName))) == keccak256(abi.encodePacked((name))));
    }

    function test_getAllianceName_SuccessfulGetAllianceName() public {
        string memory name = "alliance";
        target.createAlliance{value: 10 ether}(name);
        vm.stopPrank();
        string memory allianceName = target.getAllianceName(1);
        assert(keccak256(abi.encodePacked((allianceName))) == keccak256(abi.encodePacked((name))));
    }

    /**
    * The problem with my previous attempt was that I didn't stop the prank after creating the alliance. So, the player didn't have enough ether to join the alliance.
    */
    function test_joinAlliance_SuccessfulJoin() public {
        uint256 allianceId = 1;
        target.createAlliance{value: 10 ether}("Alliance1");
        vm.stopPrank();
        vm.deal(player, 14 ether);
        vm.startPrank(player);
        target.joinAlliance{value: 10 ether}(allianceId);
        vm.stopPrank();
        vm.startPrank(player);
        uint256 playerAllianceId = target.alliances(player);
        vm.stopPrank();
        assertEq(playerAllianceId, allianceId);
    }
}