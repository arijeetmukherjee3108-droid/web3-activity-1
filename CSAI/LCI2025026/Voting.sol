// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract voting {
    struct vote{
        address voter;
        uint candidate_no;
    }
    vote[] public votes;

    uint public total_votes = 0;
    uint public result;
    address public owner;
    bool public result_declared = false;

    modifier onlyOwner{
        require(msg.sender == owner, "You are not the owner");
        _; }

    struct candidate{
        string name;
        uint vote_count;
    }
    candidate[] public candidates;

    bool public candidates_set = false;
    bool public voting_open = false;

    constructor(){
        owner = msg.sender; }
        
    function set_candidates(string memory _name) public onlyOwner{
        require(voting_open == false, "Voting already started");
        candidates.push(candidate(_name, 0));
        candidates_set = true; }
    function start_voting() public onlyOwner{
        require(candidates_set == true, "Candidates not set");
        voting_open = true; }

    function vote_candidate(uint _candidate_no) public{
        require(voting_open == true, "Voting closed");
        require(_candidate_no < candidates.length, "Invalid candidate number");

        for(uint i = 0;i < total_votes;i++){
            require(votes[i].voter != msg.sender, "Already voted");
        }

        votes.push(vote(msg.sender, _candidate_no));
        candidates[_candidate_no].vote_count++;
        total_votes++; }

    function close_voting() public onlyOwner{
        require(voting_open == true, "Voting already closed");
        voting_open = false; }

    function declare_result() public onlyOwner{
        require(voting_open == false, "Voting still open");
        require(result_declared == false, "Result already declared");

        uint max_votes = 0;
        uint winner;

        for(uint i = 0;i < candidates.length;i++){
            if(candidates[i].vote_count > max_votes){
                max_votes = candidates[i].vote_count;
                winner = i; }}

        result = winner;
        result_declared = true; }}
