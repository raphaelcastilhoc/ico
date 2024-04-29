//SPDX-License-Identifier: Unlicense
pragma solidity 0.8.19;

import "forge-std/Test.sol";
import "contracts/BlindAuction.sol";
import "./OlympixUnitTest.sol";

contract BlindAuctionTest is OlympixUnitTest("BlindAuction") {
    address alice = address(0x456);
    address bob = address(0x789);
    address payable beneficiary = payable(address(0xff));
    BlindAuction blindAuction;

    function setUp() public {
        blindAuction = new BlindAuction(7 days, 1 days, beneficiary);

        vm.deal(alice, 1000);
        vm.deal(bob, 1000);
    }

    function test_bid_FailWhenItIsTooLateToBid() public {
        vm.startPrank(alice);
    
        vm.warp(block.timestamp + 7 days);
        vm.expectRevert(abi.encodeWithSelector(BlindAuction.TooLate.selector, blindAuction.biddingEnd()));
        blindAuction.bid(keccak256(abi.encodePacked(uint256(100), false, "")));
    
        vm.stopPrank();
    }

    function test_reveal_FailWhenItIsTooEarlyToReveal() public {
        vm.startPrank(alice);
    
        vm.expectRevert(abi.encodeWithSelector(BlindAuction.TooEarly.selector, blindAuction.biddingEnd()));
        blindAuction.reveal(new uint256[](0), new bool[](0), new bytes32[](0));
    
        vm.stopPrank();
    }

    function test_reveal_FailWhenItIsTooLateToReveal() public {
        vm.startPrank(alice);
    
        vm.warp(block.timestamp + 7 days + 1 days);
        vm.expectRevert(abi.encodeWithSelector(BlindAuction.TooLate.selector, blindAuction.revealEnd()));
        blindAuction.reveal(new uint256[](0), new bool[](0), new bytes32[](0));
    
        vm.stopPrank();
    }

    function test_reveal_FailWhenValuesLengthIsDifferentFromBidsLength() public {
        vm.startPrank(alice);
    
        blindAuction.bid{value: 100}(keccak256(abi.encodePacked(uint256(100), false, "")));
    
        vm.warp(block.timestamp + 7 days + 1);
    
        vm.expectRevert();
        blindAuction.reveal(new uint256[](0), new bool[](0), new bytes32[](0));
    
        vm.stopPrank();
    }

    function test_reveal_FailWhenFakesLengthIsNotEqualToBidsLength() public {
        vm.startPrank(alice);
    
        blindAuction.bid{value: 100}(keccak256(abi.encodePacked(uint256(100), false, "")));
    
        vm.warp(block.timestamp + 7 days + 1);
    
        vm.expectRevert();
        blindAuction.reveal(new uint256[](1), new bool[](0), new bytes32[](1));
    
        vm.stopPrank();
    }

    function test_reveal_FailWhenSecretsLengthIsNotEqualToBidsLength() public {
        vm.startPrank(alice);
    
        blindAuction.bid{value: 100}(keccak256(abi.encodePacked(uint256(100), false, "")));
    
        vm.warp(block.timestamp + 7 days + 1);
    
        vm.expectRevert();
        blindAuction.reveal(new uint256[](1), new bool[](1), new bytes32[](0));
    
        vm.stopPrank();
    }

    function test_reveal_FailWhenBlindedBidIsInvalid() public {
        vm.startPrank(alice);
    
        blindAuction.bid{value: 100}(keccak256(abi.encodePacked(uint256(100), false, "")));
    
        vm.warp(block.timestamp + 7 days + 1);
    
        blindAuction.reveal(new uint256[](1), new bool[](1), new bytes32[](1));
    
        vm.stopPrank();
    
        assertEq(alice.balance, 900);
    }

    function test_withdraw_FailWhenThereIsNoAmountToWithdraw() public {
        vm.startPrank(alice);
    
        blindAuction.withdraw();
    
        vm.stopPrank();
    }

    function test_auctionEnd_FailWhenItIsTooEarly() public {
        vm.startPrank(alice);
    
        vm.expectRevert(abi.encodeWithSelector(BlindAuction.TooEarly.selector, blindAuction.revealEnd()));
        blindAuction.auctionEnd();
    
        vm.stopPrank();
    }

    function test_auctionEnd_FailWhenAuctionEndHasAlreadyBeenCalled() public {
        vm.startPrank(alice);
    
        vm.warp(block.timestamp + 7 days + 1 days + 1);
        blindAuction.auctionEnd();
    
        vm.expectRevert(BlindAuction.AuctionEndAlreadyCalled.selector);
        blindAuction.auctionEnd();
    
        vm.stopPrank();
    }

    function test_auctionEnd_SuccessfulEnd() public {
        vm.startPrank(alice);
    
        vm.warp(block.timestamp + 7 days + 1 days + 1);
        blindAuction.auctionEnd();
    
        vm.stopPrank();
    
        assertEq(blindAuction.ended(), true);
    }
}