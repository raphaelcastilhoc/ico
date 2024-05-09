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

    function test_bid_FailWhenBiddingIsFinished() public {
        uint256 futureTimestamp = uint48(block.timestamp) + 8 days;
        vm.warp(futureTimestamp);
    
        vm.startPrank(regan);
    
        uint value = 1 ether;
        bool fake = false;
        uint secret = 123;
    
        bytes32 blindedBid = keccak256(abi.encodePacked(value, fake, secret));
        vm.expectRevert(abi.encodeWithSelector(BlindAuction.TooLate.selector, blindAuction.biddingEnd()));
        blindAuction.bid{value: value}(blindedBid);
    
        vm.stopPrank();
    }

    function test_reveal_FailWhenBiddingIsNotFinished() public {
        vm.startPrank(regan);
    
        uint[] memory reganValues = new uint[](1);
        reganValues[0] = 1 ether;
    
        bool[] memory reganFakes = new bool[](1);
        reganFakes[0] = false;
    
        bytes32[] memory reganSecrets = new bytes32[](1);
        reganSecrets[0] = bytes32(uint(123));
    
        vm.expectRevert(abi.encodeWithSelector(BlindAuction.TooEarly.selector, blindAuction.biddingEnd()));
        blindAuction.reveal(reganValues, reganFakes, reganSecrets);
    
        vm.stopPrank();
    }

    function test_reveal_SuccessfulReveal() public {
        vm.startPrank(regan);
    
        uint reganValue = 2 ether;
        bool reganFake = false;
        uint reganSecret = 123;
    
        bytes32 reganBlindedBid = keccak256(abi.encodePacked(reganValue, reganFake, reganSecret));
        blindAuction.bid{value: reganValue}(reganBlindedBid);
    
        vm.stopPrank();
    
        uint256 futureTimestamp = uint48(block.timestamp) + 8 days;
        vm.warp(futureTimestamp);
    
        vm.startPrank(regan);
    
        uint[] memory reganValues = new uint[](1);
        reganValues[0] = reganValue;
    
        bool[] memory reganFakes = new bool[](1);
        reganFakes[0] = reganFake;
    
        bytes32[] memory reganSecrets = new bytes32[](1);
        reganSecrets[0] = bytes32(uint(reganSecret));
    
        blindAuction.reveal(reganValues, reganFakes, reganSecrets);
    
        vm.stopPrank();
    
        assertEq(blindAuction.highestBid(), reganValue);
        assertEq(blindAuction.highestBidder(), regan);
        assertEq(regan.balance, 98 ether);
    }

    function test_reveal_FailWhenRevealIsFinished() public {
        uint256 futureTimestamp = uint48(block.timestamp) + 10 days;
        vm.warp(futureTimestamp);
    
        vm.startPrank(regan);
    
        uint[] memory reganValues = new uint[](1);
        reganValues[0] = 1 ether;
    
        bool[] memory reganFakes = new bool[](1);
        reganFakes[0] = false;
    
        bytes32[] memory reganSecrets = new bytes32[](1);
        reganSecrets[0] = bytes32(uint(123));
    
        vm.expectRevert(abi.encodeWithSelector(BlindAuction.TooLate.selector, blindAuction.revealEnd()));
        blindAuction.reveal(reganValues, reganFakes, reganSecrets);
    
        vm.stopPrank();
    }

    function test_reveal_FailWhenValueArgumentIsEmpty() public {
        vm.startPrank(regan);
    
        uint reganValue = 2 ether;
        bool reganFake = false;
        uint reganSecret = 123;
    
        bytes32 reganBlindedBid = keccak256(abi.encodePacked(reganValue, reganFake, reganSecret));
        blindAuction.bid{value: reganValue}(reganBlindedBid);
    
        vm.stopPrank();
    
        uint256 futureTimestamp = uint48(block.timestamp) + 8 days;
        vm.warp(futureTimestamp);
    
        vm.startPrank(regan);
    
        uint[] memory reganValues = new uint[](0);
    
        bool[] memory reganFakes = new bool[](1);
        reganFakes[0] = reganFake;
    
        bytes32[] memory reganSecrets = new bytes32[](1);
        reganSecrets[0] = bytes32(uint(reganSecret));
    
        vm.expectRevert();
        blindAuction.reveal(reganValues, reganFakes, reganSecrets);
    
        vm.stopPrank();
    }

    function test_reveal_FailWhenFakeArgumentIsEmpty() public {
        vm.startPrank(regan);
    
        uint reganValue = 2 ether;
        bool reganFake = false;
        uint reganSecret = 123;
    
        bytes32 reganBlindedBid = keccak256(abi.encodePacked(reganValue, reganFake, reganSecret));
        blindAuction.bid{value: reganValue}(reganBlindedBid);
    
        vm.stopPrank();
    
        uint256 futureTimestamp = uint48(block.timestamp) + 8 days;
        vm.warp(futureTimestamp);
    
        vm.startPrank(regan);
    
        uint[] memory reganValues = new uint[](1);
        reganValues[0] = reganValue;
    
        bool[] memory reganFakes = new bool[](0);
    
        bytes32[] memory reganSecrets = new bytes32[](1);
        reganSecrets[0] = bytes32(uint(reganSecret));
    
        vm.expectRevert();
        blindAuction.reveal(reganValues, reganFakes, reganSecrets);
    
        vm.stopPrank();
    }

    function test_reveal_FailWhenSecretArgumentIsEmpty() public {
        vm.startPrank(regan);
    
        uint reganValue = 2 ether;
        bool reganFake = false;
        uint reganSecret = 123;
    
        bytes32 reganBlindedBid = keccak256(abi.encodePacked(reganValue, reganFake, reganSecret));
        blindAuction.bid{value: reganValue}(reganBlindedBid);
    
        vm.stopPrank();
    
        uint256 futureTimestamp = uint48(block.timestamp) + 8 days;
        vm.warp(futureTimestamp);
    
        vm.startPrank(regan);
    
        uint[] memory reganValues = new uint[](1);
        reganValues[0] = reganValue;
    
        bool[] memory reganFakes = new bool[](1);
        reganFakes[0] = reganFake;
    
        bytes32[] memory reganSecrets = new bytes32[](0);
    
        vm.expectRevert();
        blindAuction.reveal(reganValues, reganFakes, reganSecrets);
    
        vm.stopPrank();
    }

    function test_reveal_FailWhenBlindedBidIsInvalid() public {
        vm.startPrank(regan);
    
        uint reganValue = 2 ether;
        bool reganFake = false;
        uint reganSecret = 123;
    
        bytes32 reganBlindedBid = keccak256(abi.encodePacked(reganValue, reganFake, reganSecret));
        blindAuction.bid{value: reganValue}(reganBlindedBid);
    
        vm.stopPrank();
    
        uint256 futureTimestamp = uint48(block.timestamp) + 8 days;
        vm.warp(futureTimestamp);
    
        vm.startPrank(regan);
    
        uint[] memory reganValues = new uint[](1);
        reganValues[0] = reganValue;
    
        bool[] memory reganFakes = new bool[](1);
        reganFakes[0] = reganFake;
    
        bytes32[] memory reganSecrets = new bytes32[](1);
        reganSecrets[0] = bytes32(uint(124));
    
        blindAuction.reveal(reganValues, reganFakes, reganSecrets);
    
        vm.stopPrank();
    
        assertEq(blindAuction.highestBid(), 0);
        assertEq(blindAuction.highestBidder(), address(0));
        assertEq(regan.balance, 98 ether);
    }

    function test_reveal_SuccessfulRevealWithFakeBid() public {
        vm.startPrank(regan);
    
        uint reganValue = 2 ether;
        bool reganFake = true;
        uint reganSecret = 123;
    
        bytes32 reganBlindedBid = keccak256(abi.encodePacked(reganValue, reganFake, reganSecret));
        blindAuction.bid{value: reganValue}(reganBlindedBid);
    
        vm.stopPrank();
    
        uint256 futureTimestamp = uint48(block.timestamp) + 8 days;
        vm.warp(futureTimestamp);
    
        vm.startPrank(regan);
    
        uint[] memory reganValues = new uint[](1);
        reganValues[0] = reganValue;
    
        bool[] memory reganFakes = new bool[](1);
        reganFakes[0] = reganFake;
    
        bytes32[] memory reganSecrets = new bytes32[](1);
        reganSecrets[0] = bytes32(uint(reganSecret));
    
        blindAuction.reveal(reganValues, reganFakes, reganSecrets);
    
        vm.stopPrank();
    
        assertEq(blindAuction.highestBid(), 0);
        assertEq(blindAuction.highestBidder(), address(0));
        assertEq(regan.balance, 100 ether);
    }

    function test_withdraw_FailWhenSenderDoesNotHavePendingReturns() public {
        vm.startPrank(regan);
    
        blindAuction.withdraw();
    
        vm.stopPrank();
    }

    function test_auctionEnd_FailWhenRevealIsNotEnd() public {
        vm.expectRevert(abi.encodeWithSelector(BlindAuction.TooEarly.selector, blindAuction.revealEnd()));
        blindAuction.auctionEnd();
    }

    function test_auctionEnd_SuccessfulAuctionEnd() public {
        uint256 futureTimestamp = uint48(block.timestamp) + 10 days;
        vm.warp(futureTimestamp);
    
        blindAuction.auctionEnd();
    
        assertEq(beneficiary.balance, 100 ether);
        assert(blindAuction.ended());
        assertEq(blindAuction.highestBid(), 0);
        assertEq(blindAuction.highestBidder(), address(0));
    }

    function test_auctionEnd_FailWhenAuctionIsAlreadyEnd() public {
        uint256 futureTimestamp = uint48(block.timestamp) + 10 days;
        vm.warp(futureTimestamp);
    
        blindAuction.auctionEnd();
    
        vm.expectRevert(BlindAuction.AuctionEndAlreadyCalled.selector);
        blindAuction.auctionEnd();
    }
}