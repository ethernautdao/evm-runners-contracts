// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";
import {EVMR} from "../src/EVMR.sol";

// forge script DeployScript --rpc-url $RPC_URL --broadcast --verify --private-key $PK --etherscan-api-key $ETHERSCAN_API -vvv
contract DeployScript is Script {
    EVMR internal evmr;

    address internal constant _backend = address(0x732253fa9C208F89180aA652f1081319e72f2fE8);

    function setUp() public {}

    function run() public {
        vm.broadcast();
        evmr = new EVMR(_backend, msg.sender);
    }
}
