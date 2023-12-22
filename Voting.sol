// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Voting {

//first we make a struct that contains the parameters of a proposal to vote
    struct Proposal {
      address target;
      bytes data;
      uint yesCount;
      uint noCount;
  }

// now i add the mapping and constants and events 
    uint constant VOTE_THRESHOLD = 10;
    mapping(uint256 => mapping(address => bool)) public voted;
    mapping(address => uint256) public previousVote;
    mapping(uint => bool) public executedProposals;
    mapping(address => bool) members;
    mapping(address => bool) members;

event ProposalCreated(uint256);
    event VoteCast(uint256, address indexed);

// this list contains all the proposals that are made and is dynamic and is initialized as an empty list
    Proposal[] public proposals;
    
    

    constructor(address[] memory _members) {
        for(uint i = 0; i < _members.length; i++) {
            members[_members[i]] = true;
        }
        members[msg.sender] = true;
    }

    // this is the old function to check if an address is a member and has been replaced by mapping
    //  function isMember(address _address) internal view returns (bool) {
    //     for (uint i = 0; i < members.length; i++) {
    //         if (members[i] == _address) {
    //             return true;
    //         }
    //     }
    //     return false;
    // }

// make a new proposal giving in the parameters to the struct. 
    function newProposal(address _target, bytes calldata _data) external {
        require(members[msg.sender]);
        proposals.push(Proposal(_target, _data, 0, 0));
        emit ProposalCreated(proposals.length-1);
    }

// this function could be split off later on. 

    function castVote (uint256 _proposalId, bool voteSupports) external {
        require(members[msg.sender]);
        Proposal storage proposal = proposals[_proposalId];
        
        // Check if the voter has already voted on this proposal
        if (voted[_proposalId][msg.sender]) {
            // If the voter has already voted, revert the previous vote
            if (voteSupports) {
                if (proposals[previousVote[msg.sender]].noCount > 0) {
                    proposals[previousVote[msg.sender]].noCount--;
                }
            } else {
                if (proposals[previousVote[msg.sender]].yesCount > 0) {
                    proposals[previousVote[msg.sender]].yesCount--;
                }
            }
        } else {
            // If the voter has not voted before, store their previous vote
            previousVote[msg.sender] = _proposalId;
        }

        // Check if the voter has voted on the proposal that they are trying to change their vote on
        if (voted[_proposalId][msg.sender]) {
            // If the voter has voted on the proposal, revert their vote
            if (voteSupports) {
                proposals[_proposalId].yesCount--;
            } else {
                proposals[_proposalId].noCount--;
            }
        }

        // Update the vote count
        if (voteSupports) {
            proposals[_proposalId].yesCount++;
        } else {
            proposals[_proposalId].noCount++;
        }

        // Mark the voter as having voted on this proposal
        voted[_proposalId][msg.sender] = true;

        // Emit the VoteCast event
        emit VoteCast(_proposalId, msg.sender);

        if(proposal.yesCount == VOTE_THRESHOLD && !executedProposals[_proposalId]) {
                (bool success, ) = proposal.target.call(proposal.data);
                require(success);
            }
        
    }

/* 
it would be better in my opintion to cut castvote in pieces because it does a lot at the moment. 
function castVote(uint256 _proposalId, bool voteSupports) external {
   require(isMember(msg.sender));
   Proposal storage proposal = getProposal(_proposalId);
   
   if (hasVotedBefore(_proposalId, msg.sender)) {
       revertPreviousVote(_proposalId, msg.sender, voteSupports);
   } else {
       previousVote[msg.sender] = _proposalId;
   }

   updateVoteCount(_proposalId, voteSupports);
   markVoterAsVoted(_proposalId, msg.sender);
   emit VoteCast(_proposalId, msg.sender);
   executeProposal(_proposalId, proposal);
}

This would be the function and is much more readable. 

// Check if the member is valid: This can be done in a separate function. It is a more simple version than before thanks to mapping.
function isMember(address _member) internal view returns (bool) {
   return members[_member];
}

//Get the proposal:  function to retrieve the proposal.
function getProposal(uint256 _proposalId) internal view returns (Proposal storage) {
   return proposals[_proposalId];
}

//Check if the voter has already voted
function hasVotedBefore(uint256 _proposalId, address _voter) internal view returns (bool) {
   return voted[_proposalId][_voter];
}

//Revert the previous vote:
function revertPreviousVote(uint256 _proposalId, address _voter, bool voteSupports) internal {
   if (voteSupports) {
       if (proposals[previousVote[_voter]].noCount > 0) {
           proposals[previousVote[_voter]].noCount--;
       }
   } else {
       if (proposals[previousVote[_voter]].yesCount > 0) {
           proposals[previousVote[_voter]].yesCount--;
       }
   }
}

//Update the vote count
function updateVoteCount(uint256 _proposalId, bool voteSupports) internal {
   if (voteSupports) {
       proposals[_proposalId].yesCount++;
   } else {
       proposals[_proposalId].noCount++;
   }
}

//Mark the voter as having voted
function markVoterAsVoted(uint256 _proposalId, address _voter) internal {
   voted[_proposalId][_voter] = true;
}

//Execute the proposal
function executeProposal(uint256 _proposalId, Proposal storage proposal) internal {
   if(proposal.yesCount >= VOTE_THRESHOLD && !executedProposals[_proposalId]) {
       (bool success, ) = proposal.target.call(proposal.data);
       require(success);
   }
}

This way I can easily have in the castvote function a breakdown of readability and understanding. 
Maybe it will cost a bit more gas, from searching online it seems:
The gas cost of a function in Solidity doesn't change whether you split it into multiple smaller functions or keep it as a single large function.
The gas cost is determined by the complexity of the operations performed, not by how the code is structured.
*/
}
