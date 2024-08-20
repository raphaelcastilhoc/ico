//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "contracts/SymbolicSamples.sol";
import "contracts/ExternalStructExternalFile.sol";
import "contracts/ExternalStructExternalContract.sol";

contract SymbolicSamplesTest is Test {
    SymbolicSamples symbolicSamples;

    function setUp() public {
        symbolicSamples = new SymbolicSamples();
    }

    function test_complexObject() public {
        Person memory person = Person ({ id : 1, car : Car ({ id : 1, name : "Car" }) });
        string memory result = symbolicSamples.complexObject(person);
        assertEq(result, "Car");
    }

    function test_bytesDifferentToHardCodedValueWithDifferentBitSize() public {
        bytes16 receiverId = 0xffffffffffffffffffffffffffffffff;
        bool result = symbolicSamples.bytesDifferentToHardCodedValueWithDifferentBitSize(receiverId);
        assertTrue(result);
    }

    function test_bytesEqualToHardCodedValue() public {
        bytes8 receiverId = 0xffffffffffffffff;
        bool result = symbolicSamples.bytesEqualToHardCodedValue(receiverId);
        assertFalse(result);
    }

    function test_bytesDifferentTo() public {
        bytes2 senderId = 0xffff;
        bytes2 receiverId = 0x0;
        bool result = symbolicSamples.bytesDifferentTo(senderId, receiverId);
        assertTrue(result);
    }

    function test_addressStateVariableComparison() public {
        address owner = address(0x0000000000000000000000000000000000000FfF);
        uint256 result = symbolicSamples.addressStateVariableComparison(owner);
        assertEq(result, 1000);
    }

    function test_bytesStateVariableComparison() public {
        bytes16 owner = 0x00ffffffffffffffffffffffffffffff;
        address result = symbolicSamples.bytesStateVariableComparison(owner);
        assertEq(result, address(0x0fff));
    }

    function test_subtractOperationBeforeComparison() public {
        bool result = symbolicSamples.subtractOperationBeforeComparison(-1, 1, 1);
        assertTrue(result);
    }

    function test_divideOperationBeforeComparison() public {
        bool result = symbolicSamples.divideOperationBeforeComparison(0, 1, 1);
        assertTrue(result);
    }

    function test_inheritedContractaddressStateVariableComparison() public {
        SubContract subContract = new SubContract(address(0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF), true);
        uint256 result = subContract.addressStateVariableComparison(address(0), address(0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF));
        assertEq(result, 1000);
    }

    function test_SpecialVariableComparison_msgSenderEqualToStateVariable() public {
        vm.startPrank(address(0x456));
        SpecialVariableComparison specialVariableComparison = new SpecialVariableComparison();
        vm.stopPrank();

        vm.startPrank(address(0x123));
        bool result = specialVariableComparison.msgSenderEqualToStateVariable();
        vm.stopPrank();
        
        assertTrue(result);
    }

    function test_StructComparison_externalStructUintComparison() public {
        StructComparison structComparison = new StructComparison();

        bool result = structComparison.externalStructUintComparison(ExternalStruct({number: 100}));
        assertTrue(result);
    }

    function test_StructComparison_internalStructUintComparison() public {
        StructComparison structComparison = new StructComparison();

        bool result = structComparison.internalStructUintComparison(StructComparison.InternalStruct({number: 201}));
        assertTrue(result);
    }

    function test_StructComparison_externalStructExternalFileUintComparison() public {
        StructComparison structComparison = new StructComparison();

        bool result = structComparison.externalStructExternalFileUintComparison(ExternalStructExternalFile({number: 300, isEnabled: true}));
        assertTrue(result);
    }

    function test_StructComparison_externalStructExternalContractUintComparison() public {
        StructComparison structComparison = new StructComparison();

        bool result = structComparison.externalStructExternalContractUintComparison(ExternalStructExternalContract.MainStruct({internalStruct: ExternalStructExternalContract.InternalStruct({number: 201}), isEnabled: true}));
        assertTrue(result);
    }

    function test_msgValueLessThanParameter() public {
        StructComparison structComparison = new StructComparison();
        bool result = structComparison.msgValueLessThanParameter{value: 0}(0);

        assertTrue(result);
    }
}