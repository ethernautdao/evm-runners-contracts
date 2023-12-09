// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {EVMR} from "../src/EVMR.sol";
import {EVMRender} from "../src/EVMRender.sol";

contract EvmrTest is Test {
    EVMR public evmr;
    EVMRender public evmrender;

    address backend = makeAddr("backend");

    function setUp() public {
        evmr = new EVMR(backend, address(this));
        evmrender = new EVMRender();

        evmr.setRenderer(address(evmrender));
        evmr.setLevelName(1, "Average");
    }

    function testSubmit() public {
        _submit(100, 50);

        _submit(50, 50);
    }

    function testSetLevelName() public {
        evmr.setLevelName(1, "TestLevel");
        assertEq(evmr.levelIdToName(1), "TestLevel");
    }

    function testSetRenderer() public {
        evmr.setRenderer(address(this));
        assertEq(address(evmr.renderer()), address(this));
    }

    function testUpdateBackend() public {
        evmr.updateBackend(address(this));
        assertEq(evmr.rolesOf(backend), 1 << 0);
    }

    function testTokenURI() public {
        _submit(100, 50);

        evmr.tokenURI(1);
    }

    function _submit(uint32 gas, uint32 size) internal {
        // declare submission struct with random fields except gas and size
        EVMR.Submission memory newSubmission = EVMR.Submission({
            id: 1,
            level_id: 1,
            gas: gas,
            size: size,
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
