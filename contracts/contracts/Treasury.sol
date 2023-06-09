// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;


contract Treasury {

    struct Proposal {
        address proposalOwner;
        bool accepted;
    }

    address public oracle;
    Proposal[] public votingResult;
    bool public hasVotingResult;
    bool public distributed;

    event FundsDistributed(address indexed recipient, uint256 amount);
    event VotingResultSet(Proposal[] result);

    constructor(address _oracle) {
        oracle = _oracle; // i.e., hackathon organizers
    }

    function setVotingResult(
        address[] calldata _proposalOwners,
        bool[] calldata _accepted
    ) external {
        require(
            _proposalOwners.length == _accepted.length,
            "Input array lengths do not match"
        );
        require(!hasVotingResult, "Voting result already set");
        require(msg.sender == oracle, "Only oracle can set the voting result");

        for (uint256 i = 0; i < _proposalOwners.length; i++) {
            Proposal memory proposal = Proposal({
                proposalOwner: _proposalOwners[i],
                accepted: _accepted[i]
            });
            votingResult.push(proposal);
        }

        hasVotingResult = true;
        emit VotingResultSet(votingResult);
    }

    function distributeFunds() external {
        require(hasVotingResult, "Voting result not set");
        require(!distributed, "Rewards already sent");

        // Distribute funds among winning proposals
        uint256 winnersCount = 0;

        for (uint256 i = 0; i < votingResult.length; i++) {
            if (votingResult[i].accepted) {
                winnersCount++;
            }
        }

        require(winnersCount > 0, "No winning proposals");

        uint256 distributionAmount = address(this).balance / winnersCount;

        for (uint256 i = 0; i < votingResult.length; i++) {
            if (votingResult[i].accepted) {
                address winner = votingResult[i].proposalOwner;
                (bool sent, ) = winner.call{value: distributionAmount}("");
                require(sent, "Failed to  withdraw");
                emit FundsDistributed(winner, distributionAmount);
            }
        }
        distributed = true;
    }
}
