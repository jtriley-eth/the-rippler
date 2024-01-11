// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.22;

import {THE_RIPPLER} from "./util/Sauce.sol";
import { RipplerCall, RipplerCallBuilder, LibRippler } from "./util/LibRippler.sol";

contract ThePeriphery {
    address public immutable theRippler;

    constructor(address rippler) {
        theRippler = rippler;
    }

    function sourceCode() public pure returns (string memory) {
        return THE_RIPPLER;
    }

    function encode(RipplerCall[] calldata calls) public pure returns (bytes memory) {
        RipplerCallBuilder memory builder = LibRippler.newBuilder();
        for (uint256 i; i < calls.length; i++) {
            builder.addCall(calls[i]);
        }
        return builder.build();
    }
}
