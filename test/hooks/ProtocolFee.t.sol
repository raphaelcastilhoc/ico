// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {TypeCasts} from "../../contracts/libs/TypeCasts.sol";
import {MessageUtils} from "../isms/IsmTestUtils.sol";
import {StandardHookMetadata} from "../../contracts/hooks/libs/StandardHookMetadata.sol";
import {IPostDispatchHook} from "../../contracts/interfaces/hooks/IPostDispatchHook.sol";

import {ProtocolFee} from "contracts/hooks/ProtocolFee.sol";

contract ProtocolFeeTest is Test {
    using TypeCasts for address;

    ProtocolFee internal fees;

    address internal alice = address(0x1); // alice the user
    address internal bob = address(0x2); // bob the beneficiary
    address internal charlie = address(0x3); // charlie the crock

    uint32 internal constant TEST_ORIGIN_DOMAIN = 1;
    uint32 internal constant TEST_DESTINATION_DOMAIN = 2;

    uint256 internal constant MAX_FEE = 1e16;
    uint256 internal constant FEE = 1e16;

    bytes internal testMessage;

    function setUp() public {
        fees = new ProtocolFee(MAX_FEE, FEE, bob, address(this));

        testMessage = _encodeTestMessage();
    }

    // ============ Helper Functions ============

    function _encodeTestMessage() internal view returns (bytes memory) {
        return MessageUtils.formatMessage(
            uint8(0),
            uint32(1),
            TEST_ORIGIN_DOMAIN,
            alice.addressToBytes32(),
            TEST_DESTINATION_DOMAIN,
            alice.addressToBytes32(),
            abi.encodePacked("Hello World")
        );
    }

    receive() external payable {}

    // ============ Tests ============

    function test_postDispatch_FailWhenMsgValueIsLessThanProtocolFee() public {
        vm.expectRevert("ProtocolFee: insufficient protocol fee");
        fees.postDispatch{value: FEE - 1}(abi.encodePacked(""), testMessage);
    }

    /**
     * The problem with my previous attempt was that I didn't consider that the refundAddress function in the StandardHookMetadata library returns the sender address when the metadata is empty. Therefore, the refund was being sent to this test contract, not to the sender of the transaction.
     */
    function test_postDispatch_SuccessfulWhenMsgValueIsGreaterThanProtocolFee() public {
        uint256 value = FEE + 1;
        fees.postDispatch{value: value}(abi.encodePacked(""), testMessage);
        assertEq(address(fees).balance, FEE);
        assertEq(alice.balance, value - FEE);
    }

    function test_postDispatch_SuccessfulWhenMsgValueIsEqualToProtocolFee() public {
        fees.postDispatch{value: FEE}(abi.encodePacked(""), testMessage);
        assertEq(address(fees).balance, FEE);
        assertEq(alice.balance, 0);
    }

    function test_setProtocolFee_FailWhenProtocolFeeExceedsMaxProtocolFee() public {
        vm.expectRevert("ProtocolFee: exceeds max protocol fee");
        fees.setProtocolFee(MAX_FEE + 1);
    }

    function test_setProtocolFee_SuccessWhenProtocolFeeDoesNotExceedMaxProtocolFee() public {
        fees.setProtocolFee(MAX_FEE);
        assertEq(fees.protocolFee(), MAX_FEE);
    }

    function test_hookType_Successful() public {
    uint8 hookType = fees.hookType();
    assertEq(hookType, uint8(IPostDispatchHook.Types.PROTOCOL_FEE));
}

    function test_collectProtocolFees_SuccessfulWhenCalledByAnyAddress() public {
    fees.postDispatch{value: FEE}(abi.encodePacked(""), testMessage);
    assertEq(address(fees).balance, FEE);
    fees.collectProtocolFees();
    assertEq(address(fees).balance, 0);
    assertEq(bob.balance, FEE);
}

    function test_quoteDispatch_Successful() public {
    uint256 quote = fees.quoteDispatch(abi.encodePacked(""), testMessage);
    assertEq(quote, FEE);
}

    function test_setBeneficiary_FailWhenBeneficiaryIsZeroAddress() public {
    vm.expectRevert("ProtocolFee: invalid beneficiary");
    fees.setBeneficiary(address(0));
}

    function test_setBeneficiary_SuccessfulWhenBeneficiaryIsNotZeroAddress() public {
    fees.setBeneficiary(charlie);
    assertEq(fees.beneficiary(), charlie);
}
}