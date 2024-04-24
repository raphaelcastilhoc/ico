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

    function test_reveal_FailWhenItIsTooLate() public {
        vm.startPrank(alice);
    
        vm.warp(block.timestamp + 8 days);
        vm.expectRevert(abi.encodeWithSelector(BlindAuction.TooLate.selector, blindAuction.revealEnd()));
        blindAuction.reveal(new uint256[](0), new bool[](0), new bytes32[](0));
    
        vm.stopPrank();
    }

    function test_reveal_SuccessfulReveal() public {
        vm.startPrank(bob);
    
        bytes32 blindedBid = keccak256(abi.encodePacked(uint256(100), false, bytes32(0)));
        blindAuction.bid{value: 100}(blindedBid);
    
        vm.warp(blindAuction.biddingEnd() + 1);
    
        uint256[] memory values = new uint256[](1);
        values[0] = 100;
        bool[] memory fakes = new bool[](1);
        fakes[0] = false;
        bytes32[] memory secrets = new bytes32[](1);
        secrets[0] = bytes32(0);
    
        blindAuction.reveal(values, fakes, secrets);
    
        assertEq(bob.balance, 900);
        assertEq(blindAuction.highestBid(), 100);
        assertEq(blindAuction.highestBidder(), bob);
    
        vm.stopPrank();
    }

    function test_reveal_FailWhenItIsTooEarly() public {
        vm.startPrank(alice);
    
        vm.warp(block.timestamp + 7 days - 1);
        vm.expectRevert(abi.encodeWithSelector(BlindAuction.TooEarly.selector, blindAuction.biddingEnd()));
        blindAuction.reveal(new uint256[](0), new bool[](0), new bytes32[](0));
    
        vm.stopPrank();
    }

    function test_reveal_FailWhenValuesLengthIsNotEqualToBidsLength() public {
        vm.startPrank(bob);
    
        bytes32 blindedBid = keccak256(abi.encodePacked(uint256(100), false, bytes32(0)));
        blindAuction.bid{value: 100}(blindedBid);
    
        vm.warp(blindAuction.biddingEnd() + 1);
    
        vm.expectRevert();
        blindAuction.reveal(new uint256[](0), new bool[](1), new bytes32[](1));
    
        vm.stopPrank();
    }

    function test_reveal_FailWhenFakesLengthIsNotEqualToBidsLength() public {
        vm.startPrank(bob);
    
        bytes32 blindedBid = keccak256(abi.encodePacked(uint256(100), false, bytes32(0)));
        blindAuction.bid{value: 100}(blindedBid);
    
        vm.warp(blindAuction.biddingEnd() + 1);
    
        vm.expectRevert();
        blindAuction.reveal(new uint256[](1), new bool[](0), new bytes32[](1));
    
        vm.stopPrank();
    }

    function test_reveal_FailWhenSecretsLengthIsNotEqualToBidsLength() public {
        vm.startPrank(bob);
    
        bytes32 blindedBid = keccak256(abi.encodePacked(uint256(100), false, bytes32(0)));
        blindAuction.bid{value: 100}(blindedBid);
    
        vm.warp(blindAuction.biddingEnd() + 1);
    
        vm.expectRevert();
        blindAuction.reveal(new uint256[](1), new bool[](1), new bytes32[](0));
    
        vm.stopPrank();
    }

    function test_reveal_FailWhenBlindedBidIsInvalid() public {
        vm.startPrank(bob);
    
        bytes32 blindedBid = keccak256(abi.encodePacked(uint256(100), false, bytes32(0)));
        blindAuction.bid{value: 100}(blindedBid);
    
        vm.warp(blindAuction.biddingEnd() + 1);
    
        uint256[] memory values = new uint256[](1);
        values[0] = 101;
        bool[] memory fakes = new bool[](1);
        fakes[0] = false;
        bytes32[] memory secrets = new bytes32[](1);
        secrets[0] = bytes32(0);
    
        blindAuction.reveal(values, fakes, secrets);
    
        assertEq(bob.balance, 900);
        assertEq(blindAuction.highestBid(), 0);
        assertEq(blindAuction.highestBidder(), address(0));
    
        vm.stopPrank();
    }

    function test_reveal_SuccessfulRevealWithFakeBid() public {
        vm.startPrank(bob);
    
        bytes32 blindedBid = keccak256(abi.encodePacked(uint256(100), true, bytes32(0)));
        blindAuction.bid{value: 100}(blindedBid);
    
        vm.warp(blindAuction.biddingEnd() + 1);
    
        uint256[] memory values = new uint256[](1);
        values[0] = 100;
        bool[] memory fakes = new bool[](1);
        fakes[0] = true;
        bytes32[] memory secrets = new bytes32[](1);
        secrets[0] = bytes32(0);
    
        blindAuction.reveal(values, fakes, secrets);
    
        assertEq(bob.balance, 1000);
        assertEq(blindAuction.highestBid(), 0);
        assertEq(blindAuction.highestBidder(), address(0));
    
        vm.stopPrank();
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

    function test_auctionEnd_SuccessfulEnd() public {
        vm.startPrank(bob);
    
        vm.warp(block.timestamp + 8 days + 1);
        blindAuction.auctionEnd();
    
        assertEq(beneficiary.balance, 0);
        assertEq(blindAuction.highestBid(), 0);
        assertEq(blindAuction.highestBidder(), address(0));
        assertEq(blindAuction.ended(), true);
    
        vm.stopPrank();
    }

    function test_auctionEnd_FailWhenAuctionEndIsAlreadyCalled() public {
        vm.startPrank(bob);
    
        vm.warp(block.timestamp + 8 days + 1);
        blindAuction.auctionEnd();
    
        vm.expectRevert(BlindAuction.AuctionEndAlreadyCalled.selector);
        blindAuction.auctionEnd();
    
        vm.stopPrank();
    }

    function test_reveal_SuccessfulRevealWithLowerBid() public {
        vm.startPrank(alice);
    
        bytes32 blindedBid = keccak256(abi.encodePacked(uint256(100), false, bytes32(0)));
        blindAuction.bid{value: 100}(blindedBid);
    
        vm.stopPrank();
    
        vm.startPrank(bob);
    
        blindedBid = keccak256(abi.encodePacked(uint256(200), false, bytes32(0)));
        blindAuction.bid{value: 200}(blindedBid);
    
        vm.warp(blindAuction.biddingEnd() + 1);
    
        uint256[] memory values = new uint256[](1);
        values[0] = 200;
        bool[] memory fakes = new bool[](1);
        fakes[0] = false;
        bytes32[] memory secrets = new bytes32[](1);
        secrets[0] = bytes32(0);
    
        blindAuction.reveal(values, fakes, secrets);
    
        assertEq(bob.balance, 800);
        assertEq(blindAuction.highestBid(), 200);
        assertEq(blindAuction.highestBidder(), bob);
    
        vm.stopPrank();
    
        vm.startPrank(alice);
    
        values[0] = 100;
        blindAuction.reveal(values, fakes, secrets);
    
        assertEq(alice.balance, 1000);
        assertEq(blindAuction.highestBid(), 200);
        assertEq(blindAuction.highestBidder(), bob);
    
        vm.stopPrank();
    }
}