// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import {TypeCasts} from "../../contracts/libs/TypeCasts.sol";
import {DomainRoutingHook} from "../../contracts/hooks/routing/DomainRoutingHook.sol";
import {FallbackDomainRoutingHook} from "../../contracts/hooks/routing/FallbackDomainRoutingHook.sol";
import {TestPostDispatchHook} from "../../contracts/test/TestPostDispatchHook.sol";
import {TestMailbox} from "../../contracts/test/TestMailbox.sol";
import {IPostDispatchHook} from "../../contracts/interfaces/hooks/IPostDispatchHook.sol";

import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

contract DomainRoutingHookTest is Test {
    using TypeCasts for address;
    using Strings for uint32;

    DomainRoutingHook public hook;
    TestPostDispatchHook public noopHook;
    TestMailbox public mailbox;

    function setUp() public virtual {
        address owner = address(this);
        uint32 origin = 0;
        mailbox = new TestMailbox(origin);
        hook = new DomainRoutingHook(address(mailbox), owner);
        noopHook = new TestPostDispatchHook();
    }

    function test_quoteDispatch(
        uint32 destination,
        bytes32 recipient,
        bytes memory body,
        bytes memory metadata,
        uint256 fee
    ) public {
        noopHook.setFee(fee);

        hook.setHook(destination, address(noopHook));

        bytes memory testMessage = mailbox.buildOutboundMessage(
            destination,
            recipient,
            body
        );

        vm.expectCall(
            address(noopHook),
            abi.encodeCall(noopHook.quoteDispatch, (metadata, testMessage))
        );
        assertEq(hook.quoteDispatch(metadata, testMessage), fee);
    }

    function test_setHooks() public {
        DomainRoutingHook.HookConfig[] memory configs = new DomainRoutingHook.HookConfig[](1);
        configs[0] = DomainRoutingHook.HookConfig(1, address(noopHook));
        hook.setHooks(configs);
        assertEq(address(hook.hooks(1)), address(noopHook));
    }
}