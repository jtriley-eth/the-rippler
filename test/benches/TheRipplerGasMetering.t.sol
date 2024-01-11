// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.22;

import { Test, Vm } from "../../lib/forge-std/src/Test.sol";
import { MainnetMetering } from "../../lib/forge-gas-metering/src/MainnetMetering.sol";

import { MockTargetSpecific } from "./../mock/MockTargetSpecific.sol";
import { RipplerCall, RipplerCallBuilder, LibRippler } from "../../src/util/LibRippler.sol";
import { huffc, deploy } from "../../src/util/Deployer.sol";

contract TheRipplerGasMetering is MainnetMetering, Test {
    using { huffc } for Vm;
    using { deploy } for bytes;

    address internal alice = vm.addr(69);
    uint128 value = 1;
    address internal theRippler;
    address[16] internal targets;

    function setUp() public {
        setUpMetering({ verbose: false });
        vm.deal(alice, value);

        theRippler = vm.huffc("src/TheRippler.huff").deploy();
        targets = [
            address(new MockTargetSpecific()),
            address(new MockTargetSpecific()),
            address(new MockTargetSpecific()),
            address(new MockTargetSpecific()),
            address(new MockTargetSpecific()),
            address(new MockTargetSpecific()),
            address(new MockTargetSpecific()),
            address(new MockTargetSpecific()),
            address(new MockTargetSpecific()),
            address(new MockTargetSpecific()),
            address(new MockTargetSpecific()),
            address(new MockTargetSpecific()),
            address(new MockTargetSpecific()),
            address(new MockTargetSpecific()),
            address(new MockTargetSpecific()),
            address(new MockTargetSpecific())
        ];
    }

    function test1() public manuallyMetered {
        meterCallAndLog({
            from: alice,
            to: theRippler,
            callData: _generateRipplerCalls(1),
            value: value,
            transaction: true,
            message: "TheRipplerGasMetering::test01"
        });
    }

    function test2() public manuallyMetered {
        meterCallAndLog({
            from: alice,
            to: theRippler,
            callData: _generateRipplerCalls(2),
            value: value,
            transaction: true,
            message: "TheRipplerGasMetering::test02"
        });
    }

    function test3() public manuallyMetered {
        meterCallAndLog({
            from: alice,
            to: theRippler,
            callData: _generateRipplerCalls(3),
            value: value,
            transaction: true,
            message: "TheRipplerGasMetering::test03"
        });
    }

    function test4() public manuallyMetered {
        meterCallAndLog({
            from: alice,
            to: theRippler,
            callData: _generateRipplerCalls(4),
            value: value,
            transaction: true,
            message: "TheRipplerGasMetering::test04"
        });
    }

    function test5() public manuallyMetered {
        meterCallAndLog({
            from: alice,
            to: theRippler,
            callData: _generateRipplerCalls(5),
            value: value,
            transaction: true,
            message: "TheRipplerGasMetering::test05"
        });
    }

    function test6() public manuallyMetered {
        meterCallAndLog({
            from: alice,
            to: theRippler,
            callData: _generateRipplerCalls(6),
            value: value,
            transaction: true,
            message: "TheRipplerGasMetering::test06"
        });
    }

    function test7() public manuallyMetered {
        meterCallAndLog({
            from: alice,
            to: theRippler,
            callData: _generateRipplerCalls(7),
            value: value,
            transaction: true,
            message: "TheRipplerGasMetering::test07"
        });
    }

    function test8() public manuallyMetered {
        meterCallAndLog({
            from: alice,
            to: theRippler,
            callData: _generateRipplerCalls(8),
            value: value,
            transaction: true,
            message: "TheRipplerGasMetering::test08"
        });
    }

    function test9() public manuallyMetered {
        meterCallAndLog({
            from: alice,
            to: theRippler,
            callData: _generateRipplerCalls(9),
            value: value,
            transaction: true,
            message: "TheRipplerGasMetering::test09"
        });
    }

    function test10() public manuallyMetered {
        meterCallAndLog({
            from: alice,
            to: theRippler,
            callData: _generateRipplerCalls(10),
            value: value,
            transaction: true,
            message: "TheRipplerGasMetering::test10"
        });
    }

    function test11() public manuallyMetered {
        meterCallAndLog({
            from: alice,
            to: theRippler,
            callData: _generateRipplerCalls(11),
            value: value,
            transaction: true,
            message: "TheRipplerGasMetering::test11"
        });
    }

    function test12() public manuallyMetered {
        meterCallAndLog({
            from: alice,
            to: theRippler,
            callData: _generateRipplerCalls(12),
            value: value,
            transaction: true,
            message: "TheRipplerGasMetering::test12"
        });
    }

    function test13() public manuallyMetered {
        meterCallAndLog({
            from: alice,
            to: theRippler,
            callData: _generateRipplerCalls(13),
            value: value,
            transaction: true,
            message: "TheRipplerGasMetering::test13"
        });
    }

    function test14() public manuallyMetered {
        meterCallAndLog({
            from: alice,
            to: theRippler,
            callData: _generateRipplerCalls(14),
            value: value,
            transaction: true,
            message: "TheRipplerGasMetering::test14"
        });
    }

    function test15() public manuallyMetered {
        meterCallAndLog({
            from: alice,
            to: theRippler,
            callData: _generateRipplerCalls(15),
            value: value,
            transaction: true,
            message: "TheRipplerGasMetering::test15"
        });
    }

    function test16() public manuallyMetered {
        meterCallAndLog({
            from: alice,
            to: theRippler,
            callData: _generateRipplerCalls(16),
            value: value,
            transaction: true,
            message: "TheRipplerGasMetering::test16"
        });
    }

    function _generateRipplerCalls(uint256 length) internal view returns (bytes memory) {
        bytes memory payload = abi.encodeCall(MockTargetSpecific.specific, (1, 2, hex"aa"));
        RipplerCallBuilder memory builder = LibRippler.newBuilder();
        for (uint256 i = 0; i < length; i++) {
            builder.addCall(RipplerCall(targets[i], value, payload));
        }
        return builder.build();
    }
}
