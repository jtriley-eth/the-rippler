// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.22;

contract MockTargetFallback {
    event Fallback(bytes data);

    fallback() external payable {
        emit Fallback(msg.data);
    }
}
