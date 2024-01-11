// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.22;

import { Vm } from "../../lib/forge-std/src/Vm.sol";

function huffc(Vm vm, string memory path) returns (bytes memory) {
    string[] memory args = new string[](3);
    args[0] = "huffc";
    args[1] = "-b";
    args[2] = path;
    return vm.ffi(args);
}

function deploy(bytes memory initcode) returns (address deployment) {
    assembly {
        deployment := create(0, add(initcode, 0x20), mload(initcode))
    }
    require(deployment != address(0), "Deployer::deploy");
}
