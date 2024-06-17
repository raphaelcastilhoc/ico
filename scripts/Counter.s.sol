// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../contracts/Counter.sol";

contract DeployCounter is Script {
    function run() public {
        vm.startBroadcast();
        new Counter();
        vm.stopBroadcast();
    }
}