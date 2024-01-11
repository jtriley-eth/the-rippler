// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.22;

struct RipplerCall {
    address target;
    uint128 value;
    bytes data;
}

struct RipplerCallBuilder {
    RipplerCall[16] calls;
    uint8 len;
}

using LibRippler for RipplerCallBuilder global;

library LibRippler {
    uint256 constant PACKED_DESTS =
        0x0006_002b_0050_0075_009a_00bf_00e4_0109_012e_0153_0178_019b_01bc_01dd_01fe_021f;

    function newRipplerCall(
        address target,
        uint128 value,
        bytes memory data
    ) internal pure returns (RipplerCall memory) {
        return RipplerCall(target, value, data);
    }

    function newBuilder() internal pure returns (RipplerCallBuilder memory builder) { }

    function addCall(
        RipplerCallBuilder memory builder,
        RipplerCall memory rCall
    ) internal pure returns (RipplerCallBuilder memory) {
        require(builder.len < 16, "LibRippler::addCall: too many calls");
        builder.calls[builder.len] = RipplerCall(rCall.target, rCall.value, rCall.data);
        builder.len++;
        return builder;
    }

    function build(RipplerCallBuilder memory builder) internal pure returns (bytes memory) {
        uint8 len = builder.len;
        if (len == 0) return new bytes(0);
        uint32 offset = 2 + (44 * uint32(len));
        bytes memory encoded = abi.encodePacked(lookupDest(len));

        for (uint256 i = len; i >= 1; i--) {
            encoded = abi.encodePacked(
                encoded,
                builder.calls[i-1].target,
                builder.calls[i-1].value,
                offset,
                uint32(builder.calls[i-1].data.length)
            );
            offset += uint32(builder.calls[i-1].data.length);
        }

        for (uint256 i = len; i >= 1; i--) {
            encoded = abi.encodePacked(encoded, builder.calls[i-1].data);
        }

        return encoded;
    }

    function lookupDest(uint8 len) internal pure returns (uint16 dest) {
        assembly {
            dest := and(shr(mul(sub(len, 0x01), 0x10), PACKED_DESTS), 0xffff)
        }
    }
}
