// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {EVMR} from "../src/EVMR.sol";
import {EVMRender} from "../src/EVMRender.sol";

contract EvmrTest is Test {
    event Transfer(address indexed from, address indexed to, uint256 indexed id);

    EVMR public evmr;
    EVMRender public evmrender;

    address backend = makeAddr("backend");

    function setUp() public {
        evmr = new EVMR(backend, address(this));
        evmrender = new EVMRender();

        evmr.setRenderer(address(evmrender));
        evmr.setLevelName(1, "Average");
    }

    function testSubmitSameID() public {
        // should mint one NFT
        vm.expectEmit(true, true, true, false);
        emit Transfer(address(0), address(this), 1);
        _submit(100, 50, 1);

        // should not mint another NFT, but updates its submission
        _submit(50, 50, 1);

        // should mint another NFT
        vm.expectEmit(true, true, true, false);
        emit Transfer(address(0), address(this), 2);
        _submit(100, 50, 2);
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
        _submit(100, 50, 1);

        // inspect SVG by decoding returned base64
        evmr.tokenURI(1);
    }

    function _submit(uint32 gas, uint32 size, uint64 id) internal {
        // declare submission struct with random fields except gas and size
        EVMR.Submission memory newSubmission = EVMR.Submission({
            id: id,
            level_id: 1,
            gas: gas,
            size: size,
            solutionType: 1,
            optimized_for: 1,
            submitted_at: 1,
            bytecode_hash: hex"f07390a96f8c90d4a560a80882a492fcf2b4b55e2c18e5f9234fe7fd29637e7c",
            user_name: "alice"
        });

        // submit struct
        vm.prank(backend);
        evmr.submit(address(this), newSubmission);
    }
}
