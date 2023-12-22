// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";
import {EVMR} from "../src/EVMR.sol";
import {EVMRender} from "../src/EVMRender.sol";

// forge script DeployNFTRenderScript --rpc-url $RPC_URL --broadcast --verify --private-key $PK --etherscan-api-key $ETHERSCAN_API -vvv
contract DeployNFTRenderScript is Script {
    EVMR internal evmr;
    EVMRender internal evmrender;

    address internal constant _backend = address(0x732253fa9C208F89180aA652f1081319e72f2fE8);

    function setUp() public {}

    function run() public {
        vm.startBroadcast();
        
        evmrender = new EVMRender();
        evmr = new EVMR(_backend, address(evmrender));

        vm.stopBroadcast();
    }
}
