// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";
import {EVMRender} from "../src/EVMRender.sol";

// forge script DeployRenderScript --rpc-url $RPC_URL --broadcast --verify --private-key $PK --etherscan-api-key $ETHERSCAN_API -vvv
contract DeployRenderScript is Script {
    EVMRender internal evmrender;

    function setUp() public {}

    function run() public {
        vm.broadcast();
        evmrender = new EVMRender();
    }
}
