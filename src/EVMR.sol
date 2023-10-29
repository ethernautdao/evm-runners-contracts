// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

contract EVMR {
    struct Submission {
        uint256 id;
        uint256 level_id;
        string level_name;
        uint256 user_id;
        string user_name;
        string bytecode;
        uint256 gas;
        uint256 size;
        uint256 submitted_at;
        string solutionType;
        string optimized_for;
    }

    mapping(address => Submission[]) public submissionsToUser;

    function submit(
        address user,
        uint256 id,
        uint256 level_id,
        string memory level_name,
        uint256 user_id,
        string memory user_name,
        string memory bytecode,
        uint256 gas,
        uint256 size,
        uint256 submitted_at,
        string memory type_,
        string memory optimized_for
    ) public {
        Submission memory newSubmission = Submission(
            id, level_id, level_name, user_id, user_name, bytecode, gas, size, submitted_at, type_, optimized_for
        );

        submissionsToUser[user].push(newSubmission);
    }

    function getSubmissionsForUser(address userAddress) public view returns (Submission[] memory) {
        return submissionsToUser[userAddress];
    }
}
