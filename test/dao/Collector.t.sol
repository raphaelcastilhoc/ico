// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "src/dao/Collector.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract MockNft is ERC721 {

    constructor() ERC721("MockNft", "MNFT") {}

    function mint(address to, uint256 tokenId) external {
        _mint(to, tokenId);
    }
}   



contract MockNftMarketplace is NftMarketplace {

    // in real life, the market place would have a dynamic number nft contracts and tokenIds, but let's just have three here
    MockNft public nft1 = new MockNft();
    MockNft public nft2 = new MockNft();
    MockNft public nft3 = new MockNft();

    function getPrice(address nftContract, uint256 nftId) external view returns (uint256) {
        if (nftContract == address(nft1)) {
            return 1 ether;
        } else if (nftContract == address(nft2)) {
            return 2 ether;
        } else if (nftContract == address(nft3)) {
            return 3 ether;
        } else {
            revert("MockNftMarketplace: invalid nft contract");
        }
    }

    function buy(address nftContract, uint256 nftId) external payable {
        require(msg.value == 1 ether, "MockNftMarketplace: incorrect price");
        MockNft nft = MockNft(nftContract);
        nft.mint(msg.sender, nftId);
    }
}

abstract contract OlympixUnitTest is Test {
   constructor(string memory targetName) {
   }
}

contract CollectorTest is OlympixUnitTest("Collector") {

    Collector collector;
    MockNftMarketplace marketplace;
    MockNft nft;

    address collectorCreator = address(0x125);
    address albert = address(0x123);
    address david = address(0x456);
    address bob = address(0x789);
    address eve = address(0xabc);

    function setUp() public {

        // give everyone 10 ether
        vm.deal(albert, 10 ether);
        vm.deal(david, 10 ether);
        vm.deal(bob, 10 ether);
        vm.deal(eve, 10 ether);

        vm.startPrank(collectorCreator);
        collector = new Collector();
        vm.stopPrank();

        marketplace = new MockNftMarketplace();
        nft = new MockNft();

    }

    function test_join_FailWhenValueIsLessThanOneEther() public {
    vm.startPrank(albert);

    uint256 value = 0.99 ether;
    vm.expectRevert(abi.encodeWithSelector(Collector.MustPayOneEth.selector, value));
    collector.join{value: value}();
    
    vm.stopPrank();
}

    function test_join_SuccessfulWhenValueIsOneEther() public {
    vm.startPrank(albert);

    collector.join{value: 1 ether}();
    
    vm.stopPrank();
    
    (uint256 votingPower, uint256 nextProposalIndexWhenJoined) = collector.memberships(albert);
    assert(votingPower == 1);
    assert(nextProposalIndexWhenJoined == 1);
    assert(collector.memberCount() == 1);
}

    function test_execute_FailWhenVotingIsStillOngoing() public {
        vm.startPrank(albert);

        collector.join{value: 1 ether}();

        address[] memory targets = new address[](0);
        uint256[] memory values = new uint256[](0);
        bytes[] memory calldatas = new bytes[](0);
        bytes32 descriptionHash = bytes32(0);
        
        collector.propose(targets, values, calldatas, descriptionHash);
        uint256 proposalId = collector.hashProposal(targets, values, calldatas, descriptionHash);

        vm.expectRevert(Collector.VotingStillOngoing.selector);
        collector.execute(targets, values, calldatas, descriptionHash);

        vm.stopPrank();
    }

    /**
* The problem with my previous attempt was that I didn't take into account that the warp function doesn't consider the current timestamp, it sets the timestamp to the value passed as parameter. So, when I called vm.warp(7 days), it set the timestamp to 7 days from the unix epoch, not 7 days from now. To fix this, I need to get the current timestamp and add 7 days to it.
*/
function test_execute_SuccessfulWhenVotingIsStillOngoing() public {
        vm.startPrank(albert);

        collector.join{value: 1 ether}();

        address[] memory targets = new address[](0);
        uint256[] memory values = new uint256[](0);
        bytes[] memory calldatas = new bytes[](0);
        bytes32 descriptionHash = bytes32(0);
        
        collector.propose(targets, values, calldatas, descriptionHash);
        uint256 proposalId = collector.hashProposal(targets, values, calldatas, descriptionHash);

        collector.vote(proposalId, Collector.VoteType.Yes);

        uint256 futureTimestamp = uint48(block.timestamp) + 6 days;
        vm.warp(futureTimestamp);

        collector.execute(targets, values, calldatas, descriptionHash);

        vm.stopPrank();

        (uint256 id,
        uint256 index,
        address proposer,
        uint256 createdAt,
        uint256 eligibleVoterCount,
        bool executed,
        uint256 noVotes,
        uint256 yesVotes,
        uint256 voteCount) = collector.proposals(proposalId);

        assert(executed == false);
        assert(voteCount == 1);
        assert(yesVotes == 1);
    }

    /**
* The problem with my previous attempt was that I didn't take into account that the warp function doesn't consider the current timestamp, it sets the timestamp to the value passed as parameter. So, when I called vm.warp(7 days), it set the timestamp to 7 days from the unix epoch, not 7 days from now. To fix this, I need to get the current timestamp and add 7 days to it.
*/
function test_execute_SuccessfulWhenVoteCountIsGreaterThanQuorum() public {
        vm.startPrank(albert);

        collector.join{value: 1 ether}();

        address[] memory targets = new address[](0);
        uint256[] memory values = new uint256[](0);
        bytes[] memory calldatas = new bytes[](0);
        bytes32 descriptionHash = bytes32(0);
        
        collector.propose(targets, values, calldatas, descriptionHash);
        uint256 proposalId = collector.hashProposal(targets, values, calldatas, descriptionHash);

        collector.vote(proposalId, Collector.VoteType.Yes);

        uint256 futureTimestamp = uint48(block.timestamp) + 7 days;
        vm.warp(futureTimestamp);

        collector.execute(targets, values, calldatas, descriptionHash);

        vm.stopPrank();

        (uint256 id,
        uint256 index,
        address proposer,
        uint256 createdAt,
        uint256 eligibleVoterCount,
        bool executed,
        uint256 noVotes,
        uint256 yesVotes,
        uint256 voteCount) = collector.proposals(proposalId);

        assert(executed == true);
        assert(voteCount == 1);
        assert(yesVotes == 1);
    }

    function test_vote_FailWhenSenderIsNotMember() public {
    vm.expectRevert(Collector.NonMember.selector);
    collector.vote(0, Collector.VoteType.Yes);
}

    function test_vote_FailWhenSenderJoinedTooLateToVote() public {
        vm.startPrank(albert);

        collector.join{value: 1 ether}();

        address[] memory targets = new address[](0);
        uint256[] memory values = new uint256[](0);
        bytes[] memory calldatas = new bytes[](0);
        bytes32 descriptionHash = bytes32(0);
        
        collector.propose(targets, values, calldatas, descriptionHash);
        uint256 proposalId = collector.hashProposal(targets, values, calldatas, descriptionHash);

        vm.stopPrank();

        vm.startPrank(bob);

        collector.join{value: 1 ether}();

        vm.expectRevert(Collector.JoinedTooLateToVote.selector);
        collector.vote(proposalId, Collector.VoteType.Yes);

        vm.stopPrank();
    }

    function test_vote_FailWhenSenderAlreadyVoted() public {
        vm.startPrank(albert);

        collector.join{value: 1 ether}();

        address[] memory targets = new address[](0);
        uint256[] memory values = new uint256[](0);
        bytes[] memory calldatas = new bytes[](0);
        bytes32 descriptionHash = bytes32(0);
        
        collector.propose(targets, values, calldatas, descriptionHash);
        uint256 proposalId = collector.hashProposal(targets, values, calldatas, descriptionHash);

        collector.vote(proposalId, Collector.VoteType.Yes);

        vm.expectRevert(Collector.HasAlreadyVoted.selector);
        collector.vote(proposalId, Collector.VoteType.Yes);

        vm.stopPrank();
    }

    function test_vote_FailWhenVotingHasEnded() public {
        vm.startPrank(albert);

        collector.join{value: 1 ether}();

        address[] memory targets = new address[](0);
        uint256[] memory values = new uint256[](0);
        bytes[] memory calldatas = new bytes[](0);
        bytes32 descriptionHash = bytes32(0);
        
        collector.propose(targets, values, calldatas, descriptionHash);
        uint256 proposalId = collector.hashProposal(targets, values, calldatas, descriptionHash);

        uint256 futureTimestamp = uint48(block.timestamp) + 7 days;
        vm.warp(futureTimestamp);

        vm.expectRevert(Collector.VotingHasEnded.selector);
        collector.vote(proposalId, Collector.VoteType.Yes);

        vm.stopPrank();
    }

    function test_vote_SuccessfulWhenSenderVoteNo() public {
        vm.startPrank(albert);

        collector.join{value: 1 ether}();

        address[] memory targets = new address[](0);
        uint256[] memory values = new uint256[](0);
        bytes[] memory calldatas = new bytes[](0);
        bytes32 descriptionHash = bytes32(0);
        
        collector.propose(targets, values, calldatas, descriptionHash);
        uint256 proposalId = collector.hashProposal(targets, values, calldatas, descriptionHash);

        collector.vote(proposalId, Collector.VoteType.No);

        vm.stopPrank();

        (uint256 id,
        uint256 index,
        address proposer,
        uint256 createdAt,
        uint256 eligibleVoterCount,
        bool executed,
        uint256 noVotes,
        uint256 yesVotes,
        uint256 voteCount) = collector.proposals(proposalId);

        assert(noVotes == 1);
        assert(voteCount == 1);
    }

    function test_voteBySig_FailWhenInvalidSignature() public {
        vm.expectRevert(Collector.InvalidSignature.selector);
        collector.voteBySig(0, 0, 0, bytes32(0), bytes32(0));
    }

    function test_recordVotesBySigs_FailWhenBulkVoteArgsAreInvalid() public {
        vm.expectRevert(abi.encodeWithSelector(Collector.InvalidBulkVoteArgs.selector, 1, 0, 0, 0, 0));
        collector.recordVotesBySigs(new uint256[](1), new uint8[](0), new uint8[](0), new bytes32[](0), new bytes32[](0));
    }

    /**
* The problem with my previous attempt was that I didn't take into account that the collectorCreator didn't have enough ether to join the collector. To fix this, I need to give the collectorCreator 10 ether.
*/
function test_buyFromNftMarketplace_SuccessfulWhenMaxPriceIsGreaterThanPrice() public {
        vm.deal(collectorCreator, 10 ether);

        vm.startPrank(collectorCreator);

        collector.join{value: 10 ether}();

        address nftContract = address(marketplace.nft1());
        uint256 nftId = 1;
        uint256 maxPrice = 2 ether;

        address[] memory targets = new address[](1);
        targets[0] = address(collector);

        uint256[] memory values = new uint256[](1);
        values[0] = 1 ether;

        bytes[] memory calldatas = new bytes[](1);
        calldatas[0] = abi.encodeWithSelector(Collector.buyFromNftMarketplace.selector, marketplace, nftContract, nftId, maxPrice);

        bytes32 descriptionHash = bytes32(0);

        collector.propose(targets, values, calldatas, descriptionHash);
        uint256 proposalId = collector.hashProposal(targets, values, calldatas, descriptionHash);

        collector.vote(proposalId, Collector.VoteType.Yes);

        uint256 futureTimestamp = uint48(block.timestamp) + 7 days;
        vm.warp(futureTimestamp);

        collector.execute(targets, values, calldatas, descriptionHash);

        vm.stopPrank();

        (uint256 id,
        uint256 index,
        address proposer,
        uint256 createdAt,
        uint256 eligibleVoterCount,
        bool executed,
        uint256 noVotes,
        uint256 yesVotes,
        uint256 voteCount) = collector.proposals(proposalId);

        assert(executed == true);
        assert(voteCount == 1);
        assert(yesVotes == 1);
    }

    function test_onERC721Received_SuccessfulWhenCalled() public {
    bytes4 result = collector.onERC721Received(address(0), address(0), 0, "");
    assert(result == collector.onERC721Received.selector);
}
}