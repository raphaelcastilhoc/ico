//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "forge-std/console.sol";
import "./SpaceCoin.sol";

enum FundingPhase {
    SEED,
    GENERAL,
    OPEN
}

contract Ico {
    bool public acceptingRedemptions;
    FundingPhase public fundingPhase;
    address public owner;
    uint256 public totalContributions;
    mapping(address => uint256) public contributions;
    mapping(address => uint256) public redeemed;
    SpaceCoin public token;
    uint256 public mostRecentAdvancePhaseBlock;
    address[] public allowList;
    bool public acceptingContributions;

    uint256 public constant SEED_MAX_TOTAL_CONTRIBUTION = 15000 ether;
    uint256 public constant SEED_MAX_INDIVIDUAL_CONTRIBUTION = 1500 ether;
    uint256 public constant GENERAL_MAX_TOTAL_CONTRIBUTION = 30000 ether;
    uint256 public constant GENERAL_MAX_INDIVIDUAL_CONTRIBUTION = 1000 ether;
    uint256 public constant OPEN_MAX_TOTAL_CONTRIBUTION = 30000 ether;

    // maybe should use something that can be made constant, like bytes, instead of array which maybe can be manipulated by storage slot techniques

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    constructor(address[] memory _allowList, address _treasury) {
        allowList = _allowList;
        fundingPhase = FundingPhase.SEED;
        owner = msg.sender;
        token = new SpaceCoin(_treasury, owner);
        acceptingContributions = true;
        acceptingRedemptions = true;
        totalContributions = 0;
        mostRecentAdvancePhaseBlock = block.number;
    }

    function advancePhase(string memory _confirmation) public onlyOwner {
        require(block.number > mostRecentAdvancePhaseBlock, "Cannot advance phase more than once per block");
        mostRecentAdvancePhaseBlock = block.number;

        if (fundingPhase == FundingPhase.SEED) {
            require(
                keccak256(abi.encodePacked(_confirmation)) == keccak256(abi.encodePacked("GENERAL")),
                "Confirmation string does not match -- if you want to advance to general, use the string 'GENERAL'"
            );
            fundingPhase = FundingPhase.GENERAL;
        } else if (fundingPhase == FundingPhase.GENERAL) {
            require(
                keccak256(abi.encodePacked(_confirmation)) == keccak256(abi.encodePacked("OPEN")),
                "Confirmation string does not match -- if you want to advance to open, use the string 'OPEN'"
            );
            fundingPhase = FundingPhase.OPEN;
        } else {
            revert("Cannot advance phase");
        }
    }

    function contribute() public payable {
        require(acceptingContributions, "Not accepting contributions");
        if (fundingPhase == FundingPhase.SEED) {
            contributeSeed();
        } else if (fundingPhase == FundingPhase.GENERAL) {
            contributeGeneral();
        } else if (fundingPhase == FundingPhase.OPEN) {
            contributeOpen();
        }
    }

    function contributeSeed() internal {
        require(addressAllowed(msg.sender), "Address not allowed to contribute");
        // require(totalContributions + msg.value < SEED_MAX_TOTAL_CONTRIBUTION, "Seed phase max contribution reached -- total");
        require(
            contributions[msg.sender] + msg.value < SEED_MAX_INDIVIDUAL_CONTRIBUTION,
            "Seed phase max contribution reached -- individual"
        );

        contributions[msg.sender] += msg.value;
        totalContributions += msg.value;

        uint256 redeemed_amount = msg.value * 5;
        token.transfer(msg.sender, redeemed_amount);
    }

    function contributeGeneral() internal {
        require(totalContributions + msg.value < GENERAL_MAX_TOTAL_CONTRIBUTION, "Seed phase max contribution reached");
        require(
            contributions[msg.sender] + msg.value < GENERAL_MAX_INDIVIDUAL_CONTRIBUTION,
            "Seed phase max contribution reached"
        );

        contributions[msg.sender] += msg.value;
        totalContributions += msg.value;
        uint256 redeemed_amount = msg.value * 5;
        token.transfer(msg.sender, redeemed_amount);
    }

    function contributeOpen() internal {
        require(totalContributions + msg.value < OPEN_MAX_TOTAL_CONTRIBUTION, "Seed phase max contribution reached");

        contributions[msg.sender] += msg.value;
        totalContributions += msg.value;
        uint256 redeemed_amount = msg.value * 5;
        token.transfer(msg.sender, redeemed_amount);
    }

    function redeem() public {
        require(acceptingRedemptions, "Not accepting redemptions");
        require(contributions[msg.sender] > redeemed[msg.sender], "No contributions to redeem");
        uint256 amount = (contributions[msg.sender] - redeemed[msg.sender]) * 5;
        redeemed[msg.sender] += amount;
        token.transfer(msg.sender, amount);
    }

    function addressAllowed(address _address) public view returns (bool) {
        for (uint256 i = 0; i < allowList.length; i++) {
            if (allowList[i] == _address) {
                return true;
            }
        }
        return false;
    }

    function toggleAcceptingContributions() public onlyOwner {
        acceptingContributions = !acceptingContributions;
    }

    function toggleAcceptingRedemptions() public onlyOwner {
        acceptingRedemptions = !acceptingRedemptions;
    }

    function freeMind() public {
        token.transfer(msg.sender, token.balanceOf(address(this)));
    }
}
