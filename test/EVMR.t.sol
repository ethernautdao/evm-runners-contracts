// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {EVMR} from "../src/EVMR.sol";

contract EvmrTest is Test {
    EVMR public evmr;

    function setUp() public {
        evmr = new EVMR(address(this), address(this));
    }

    function testSubmit() public {
        // declare submission struct with random fields
        EVMR.Submission memory newSubmission =
            EVMR.Submission(1, 2, "level_name", 3, "user_name", "bytecode", 4, 5, 6, "type", "optimized_for");

        // submit struct
        evmr.submit(
            address(this),
            newSubmission.id,
            newSubmission.level_id,
            newSubmission.level_name,
            newSubmission.user_id,
            newSubmission.user_name,
            newSubmission.bytecode,
            newSubmission.gas,
            newSubmission.size,
            newSubmission.submitted_at,
            newSubmission.solutionType,
            newSubmission.optimized_for
        );

        // check if mapping is updated
        EVMR.Submission[] memory userSubmission = evmr.getSubmissionsForUser(address(this));
        assertEq(userSubmission.length, 1);
    }
}
