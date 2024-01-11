// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.22;

contract MockTargetSpecific {
    event Specific(uint256 indexed a, uint8 indexed b, bytes data);

    function specific(uint256 a, uint8 b, bytes memory data) external payable {
        emit Specific(a, b, data);
    }
}
