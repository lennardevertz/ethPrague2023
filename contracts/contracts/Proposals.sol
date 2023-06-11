// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

error not_in_proposalPeriod();
error not_in_votingPeriod();

contract ProposalVoting {

    struct Proposal {
        string description;
        address proposalOwner;
        uint256 votes;
        bool accepted;
    }

    struct Vote {
        uint256 proposalIndex;
        uint8 decision; // 0 for decline, 1 for accept
    }


    IERC20 public votingToken;

    Proposal[] public proposals;
    uint256 public hackathonEndTime; // Hackathon end timestamp
    uint256 public TRANSITION_PERIOD = 90 days; // Transition period after hackathon ends
    uint256 public SUBMISSION_PERIOD = TRANSITION_PERIOD + 30 days; // Submission duration
    uint256 public VOTING_PERIOD = SUBMISSION_PERIOD + 10 days; // VOTING duration
    uint256 public castedVotes;

    event ProposalSubmitted(address indexed recipient, string message);
    event VoteCasted(address indexed sender, address indexed proposalOwner, uint8 accept);

    constructor() {
    }

    function submitProposal(string calldata _description) external {
        if (hackathonEndTime + SUBMISSION_PERIOD < block.timestamp || block.timestamp < hackathonEndTime + TRANSITION_PERIOD) {
            revert not_in_proposalPeriod();
        }

        Proposal memory newProposal = Proposal({
            description: _description,
            proposalOwner: msg.sender,
            votes: 0,
            accepted: false
        });

        proposals.push(newProposal);

        emit ProposalSubmitted(msg.sender, _description);
    }

    function castVote(Vote[] calldata _votes) external {
        if (hackathonEndTime + SUBMISSION_PERIOD > block.timestamp || block.timestamp > hackathonEndTime + VOTING_PERIOD) {
            revert not_in_votingPeriod();
        }

        require(_votes.length == proposals.length, "Invalid number of votes");

        require(votingToken.transferFrom(msg.sender, address(this), 10**18), "No votes available");
        castedVotes += 1;

        for (uint256 i = 0; i < _votes.length; i++) {
            Vote calldata vote = _votes[i];
            require(vote.decision == 0 || vote.decision == 1, "Invalid vote decision");

            proposals[i].votes += vote.decision;

            emit VoteCasted(msg.sender, proposals[i].proposalOwner, vote.decision);
        }
    }

    function proposalsCount() public view returns (uint256) {
        // You need to implement this function to return the total number of proposals submitted
        return proposals.length;
    }

    // HELPER FUNCTION, delete for live version
    function setTimes(uint256 _hackathonEndTime, uint256 _transitionPeriod, uint256 _submissionEndDate, uint256 votingEndDate, address _votingTokenAddress) external {
        TRANSITION_PERIOD = _transitionPeriod;
        SUBMISSION_PERIOD = _submissionEndDate;
        VOTING_PERIOD = votingEndDate;
        hackathonEndTime = _hackathonEndTime;
        votingToken = IERC20(_votingTokenAddress);
    }

}
