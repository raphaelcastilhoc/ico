// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";

import {StaticAggregationHook} from "../../contracts/hooks/aggregation/StaticAggregationHook.sol";
import {StaticAggregationHookFactory} from "../../contracts/hooks/aggregation/StaticAggregationHookFactory.sol";
import {TestPostDispatchHook} from "../../contracts/test/TestPostDispatchHook.sol";
import {IPostDispatchHook} from "../../contracts/interfaces/hooks/IPostDispatchHook.sol";

contract AggregationHookTest is Test {
    StaticAggregationHookFactory internal factory;
    StaticAggregationHook internal hook;

    uint256 internal constant PER_HOOK_GAS_AMOUNT = 25000;
    address[] internal hooksDeployed;

    function setUp() public {
        factory = new StaticAggregationHookFactory();
        uint8 hooks = 3;
        uint256 fee = PER_HOOK_GAS_AMOUNT;
        hooksDeployed = deployHooks(hooks, fee);

    }

    function deployHooks(uint8 n, uint256 fee) internal returns (address[] memory) {
        address[] memory hooks = new address[](n);
        for (uint8 i = 0; i < n; i++) {
            TestPostDispatchHook subHook = new TestPostDispatchHook();
            subHook.setFee(fee);
            hooks[i] = address(subHook);
        }
        hook = StaticAggregationHook(factory.deploy(hooks));
        return hooks;
    }

    function testPostDispatch() public {
        uint256 fee = PER_HOOK_GAS_AMOUNT;
        uint256 _msgValue = hooksDeployed.length * fee;

        bytes memory message = abi.encodePacked("hello world");
        for (uint256 i = 0; i < hooksDeployed.length; i++) {
            vm.expectCall(
                hooksDeployed[i],
                PER_HOOK_GAS_AMOUNT,
                abi.encodeCall(
                    TestPostDispatchHook(hooksDeployed[i]).postDispatch,
                    ("", "hello world")
                )
            );
        }
        hook.postDispatch{value: _msgValue}("", message);
    }

    function test_hookType() public {
    uint8 hookType = hook.hookType();
    assertEq(hookType, uint8(IPostDispatchHook.Types.AGGREGATION));
}
}