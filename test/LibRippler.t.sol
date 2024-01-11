// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.22;

import { Test } from "../lib/forge-std/src/Test.sol";

import { RipplerCall, RipplerCallBuilder, LibRippler } from "../src/util/LibRippler.sol";
import { ThePeriphery } from "../src/ThePeriphery.sol";

contract LibRipplerTest is Test {
    function testBuild() public {
        uint8 callsLength = 1;
        address target = address(1);
        uint128 value = 2;
        uint32 ptr = 46;
        bytes memory data = hex"aabbccdd";

        bytes memory encoded = LibRippler.newBuilder()
            .addCall(LibRippler.newRipplerCall(target, value, data))
            .build();

        assertEq(LibRippler.lookupDest(callsLength), uint16(readNumber(encoded, 0, 16)));
        assertEq(target, address(uint160(readNumber(encoded, 2, 160))));
        assertEq(value, uint128(readNumber(encoded, 22, 128)));
        assertEq(ptr, uint32(readNumber(encoded, 38, 32)));
        assertEq(data.length, uint32(readNumber(encoded, 42, 32)));
        assertEq(data[0], encoded[46]);
        assertEq(data[1], encoded[47]);
        assertEq(data[2], encoded[48]);
        assertEq(data[3], encoded[49]);
    }

    function testBuildOverflow() public {
        vm.expectRevert("LibRippler::addCall: too many calls");
        RipplerCall memory rCall = RipplerCall(address(0), 0, new bytes(0));
        RipplerCallBuilder memory builder = LibRippler.newBuilder();
        builder.addCall(rCall);
        builder.addCall(rCall);
        builder.addCall(rCall);
        builder.addCall(rCall);
        builder.addCall(rCall);
        builder.addCall(rCall);
        builder.addCall(rCall);
        builder.addCall(rCall);
        builder.addCall(rCall); 
        builder.addCall(rCall);
        builder.addCall(rCall);
        builder.addCall(rCall);
        builder.addCall(rCall);
        builder.addCall(rCall);
        builder.addCall(rCall);
        builder.addCall(rCall);
        builder.addCall(rCall);
    }

    function testFuzzBuild(RipplerCall[] memory rCalls) public {
        if (rCalls.length > 16) {
            vm.expectRevert("LibRippler::addCall: too many calls");
        }

        RipplerCallBuilder memory builder = LibRippler.newBuilder();
        for (uint256 i = 0; i < rCalls.length; i++) {
            builder.addCall(rCalls[i]);
        }
        emit log_uint(builder.len);
        bytes memory encoded = builder.build();

        if (rCalls.length > 16) return;

        uint256 offset = 2;
        for (uint256 i = rCalls.length; i >= 1; i--) {
            assertEq(rCalls[i-1].target, address(uint160(readNumber(encoded, offset, 160))));
            offset += 20;
            assertEq(rCalls[i-1].value, uint128(readNumber(encoded, offset, 128)));
            offset += 20;
            assertEq(uint32(rCalls[i-1].data.length), uint32(readNumber(encoded, offset, 32)));
            offset += 4;
        }
    }

    function readNumber(bytes memory data, uint256 start, uint256 bits) internal pure returns (uint256 word) {
        // literally how hard can it be to slice a byte array
        assembly {
            word := shr(sub(256, bits), mload(add(data, add(start, 0x20))))
        }
    }
}
