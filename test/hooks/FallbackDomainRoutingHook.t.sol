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


contract FallbackDomainRoutingHookTest is Test {
    TestPostDispatchHook public fallbackHook;
    DomainRoutingHook public hook;
    TestPostDispatchHook public noopHook;
    TestMailbox public mailbox;

    function setUp() public {
        address owner = address(this);
        uint32 origin = 0;
        mailbox = new TestMailbox(origin);
        fallbackHook = new TestPostDispatchHook();
        noopHook = new TestPostDispatchHook();
        hook = new FallbackDomainRoutingHook(address(mailbox), owner, address(fallbackHook));
    }

    function test_quoteDispatch_whenDestinationUnenrolled(
        uint32 destination,
        bytes32 recipient,
        bytes memory body,
        bytes memory metadata,
        uint256 fee
    ) public {
        fallbackHook.setFee(fee);

        bytes memory testMessage = mailbox.buildOutboundMessage(
            destination,
            recipient,
            body
        );

        vm.expectCall(
            address(fallbackHook),
            abi.encodeCall(fallbackHook.quoteDispatch, (metadata, testMessage))
        );
        assertEq(hook.quoteDispatch(metadata, testMessage), fee);
    }

    function test_hookType_Successful() public {
    uint8 result = hook.hookType();
    assertEq(result, uint8(IPostDispatchHook.Types.FALLBACK_ROUTING));
}
}