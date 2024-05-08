//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "contracts/BlindAuction.sol";
import "./OlympixUnitTest.sol";

contract BlindAuctionTest is OlympixUnitTest("BlindAuction") {
    address beneficiary = address(0x123);
    address regan = address(0x456);
    address chris = address(0x789);

    BlindAuction blindAuction;

    function setUp() public {
        vm.deal(beneficiary, 100 ether);
        vm.deal(regan, 100 ether);
        vm.deal(chris, 100 ether);

        vm.startPrank(beneficiary);
        blindAuction = new BlindAuction(7 days, 2 days, payable(beneficiary));
        vm.stopPrank();
    }

    function test_bid_FailWhenItIsTooLateToBid() public {
        vm.startPrank(regan);
    
        vm.warp(blindAuction.biddingEnd() + 1);
        vm.expectRevert(abi.encodeWithSelector(BlindAuction.TooLate.selector, blindAuction.biddingEnd()));
        blindAuction.bid(keccak256(abi.encodePacked(uint256(1), false, "")));
    
        vm.stopPrank();
    }

    function test_bid_SuccessfulBid() public {
        vm.startPrank(regan);
    
        blindAuction.bid{value: 1 ether}(keccak256(abi.encodePacked(uint256(1), false, "")));
    
        vm.stopPrank();
    }

    function test_reveal_FailWhenItIsTooEarly() public {
        vm.startPrank(regan);
    
        vm.expectRevert(abi.encodeWithSelector(BlindAuction.TooEarly.selector, blindAuction.biddingEnd()));
        blindAuction.reveal(new uint256[](0), new bool[](0), new bytes32[](0));
    
        vm.stopPrank();
    }

    function test_reveal_FailWhenItIsTooLate() public {
        vm.startPrank(regan);
    
        vm.warp(blindAuction.revealEnd() + 1);
    
        vm.expectRevert(abi.encodeWithSelector(BlindAuction.TooLate.selector, blindAuction.revealEnd()));
        blindAuction.reveal(new uint256[](0), new bool[](0), new bytes32[](0));
    
        vm.stopPrank();
    }

    function test_reveal_FailWhenValuesLengthIsNotEqualToBidsLength() public {
        vm.startPrank(regan);
    
        blindAuction.bid{value: 1 ether}(keccak256(abi.encodePacked(uint256(1), false, "")));
    
        vm.warp(blindAuction.biddingEnd() + 1);
    
        vm.expectRevert();
        blindAuction.reveal(new uint256[](0), new bool[](0), new bytes32[](0));
    
        vm.stopPrank();
    }

    function test_reveal_FailWhenFakesLengthIsNotEqualToBidsLength() public {
        vm.startPrank(regan);
    
        blindAuction.bid{value: 1 ether}(keccak256(abi.encodePacked(uint256(1), false, "")));
    
        vm.warp(blindAuction.biddingEnd() + 1);
    
        vm.expectRevert();
        blindAuction.reveal(new uint256[](1), new bool[](0), new bytes32[](1));
    
        vm.stopPrank();
    }

    function test_reveal_SuccessfulReveal() public {
        vm.startPrank(regan);
    
        blindAuction.bid{value: 1 ether}(keccak256(abi.encodePacked(uint256(1), false, "")));
    
        vm.warp(blindAuction.biddingEnd() + 1);
    
        blindAuction.reveal(new uint256[](1), new bool[](1), new bytes32[](1));
    
        assertEq(regan.balance, 99 ether);
    
        vm.stopPrank();
    }

    function test_reveal_FailWhenSecretsLengthIsNotEqualToBidsLength() public {
        vm.startPrank(regan);
    
        blindAuction.bid{value: 1 ether}(keccak256(abi.encodePacked(uint256(1), false, "")));
    
        vm.warp(blindAuction.biddingEnd() + 1);
    
        vm.expectRevert();
        blindAuction.reveal(new uint256[](1), new bool[](1), new bytes32[](0));
    
        vm.stopPrank();
    }

    function test_withdraw_FailWhenAmountIsZero() public {
        vm.startPrank(regan);
    
        blindAuction.withdraw();
    
        vm.stopPrank();
    }

    function test_auctionEnd_FailWhenItIsTooEarly() public {
        vm.startPrank(chris);
    
        vm.expectRevert(abi.encodeWithSelector(BlindAuction.TooEarly.selector, blindAuction.revealEnd()));
        blindAuction.auctionEnd();
    
        vm.stopPrank();
    }

    function test_auctionEnd_SuccessfulEnd() public {
        vm.startPrank(chris);
    
        vm.warp(blindAuction.revealEnd() + 1);
        blindAuction.auctionEnd();
    
        assertEq(blindAuction.ended(), true);
        assertEq(beneficiary.balance, 100 ether);
    
        vm.stopPrank();
    }

    function test_auctionEnd_FailWhenAuctionEndIsAlreadyCalled() public {
        vm.startPrank(chris);
    
        vm.warp(blindAuction.revealEnd() + 1);
        blindAuction.auctionEnd();
    
        vm.expectRevert(BlindAuction.AuctionEndAlreadyCalled.selector);
        blindAuction.auctionEnd();
    
        vm.stopPrank();
    }
}