// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {EVMR} from "../src/EVMR.sol";

contract EvmrTest is Test {
    EVMR public evmr;

    address backend = makeAddr("backend");

    function setUp() public {
        evmr = new EVMR(backend, address(this));
    }

    function testSubmit() public {
        // declare submission struct with random fields
        EVMR.Submission memory newSubmission = EVMR.Submission({
            id: 1,
            level_id: 1,
            gas: 1,
            size: 1,
            solutionType: 1,
            optimized_for: 1,
            submitted_at: 1,
            user_name: "user1"
        });

        // submit struct
        vm.prank(backend);
        evmr.submit(address(this), newSubmission);
    }
}
