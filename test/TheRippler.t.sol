// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.22;

import { Test, Vm } from "../lib/forge-std/src/Test.sol";

import { MockTargetFallback } from "./mock/MockTargetFallback.sol";
import { MockTargetSpecific } from "./mock/MockTargetSpecific.sol";
import { RipplerCall, RipplerCallBuilder, LibRippler } from "../src/util/LibRippler.sol";
import { huffc, deploy } from "../src/util/Deployer.sol";

contract TheRipplerTest is Test {
    using { huffc } for Vm;
    using { deploy } for bytes;

    address internal alice = vm.addr(1);
    address internal theRippler;
    address internal mockTargetFallback;
    address internal mockTargetSpecific;

    modifier asActor(address _actor) {
        vm.startPrank(_actor);
        _;
        vm.stopPrank();
    }

    function setUp() public {
        theRippler = vm.huffc("src/TheRippler.huff").deploy();
        mockTargetFallback = address(new MockTargetFallback());
        mockTargetSpecific = address(new MockTargetSpecific());
    }

    function testSingle() public asActor(alice) {
        uint128 value = 1;
        vm.deal(alice, value);
        bytes memory payload = abi.encodeCall(MockTargetSpecific.specific, (1, 2, hex"aa"));

        vm.expectCall(mockTargetSpecific, value, payload, 1);

        (bool succ, bytes memory ret) = theRippler.call{ value: value }(
            LibRippler
                .newBuilder()
                .addCall(RipplerCall(mockTargetSpecific, value, payload))
                .build()
        );

        assertTrue(succ);
        assertEq(ret.length, 0);
    }

    function testDouble() public asActor(alice) {
        uint128 value = 1;
        vm.deal(alice, value * 2);
        bytes memory payload = abi.encodeCall(MockTargetSpecific.specific, (1, 2, hex"aa"));

        vm.expectCall(mockTargetSpecific, value, payload, 2);

        (bool succ, bytes memory ret) = theRippler.call{ value: value * 2 }(
            LibRippler
                .newBuilder()
                .addCall(RipplerCall(mockTargetSpecific, value, payload))
                .addCall(RipplerCall(mockTargetSpecific, value, payload))
                .build()
        );

        assertTrue(succ);
        assertEq(ret.length, 0);
    }

    function test16() public asActor(alice) {
        uint128 value = 1;
        vm.deal(alice, value * 16);
        bytes memory payload = abi.encodeCall(MockTargetSpecific.specific, (1, 2, hex"aa"));

        vm.expectCall(mockTargetSpecific, value, payload, 16);

        RipplerCallBuilder memory builder = LibRippler.newBuilder();
        builder.addCall(RipplerCall(mockTargetSpecific, value, payload));
        builder.addCall(RipplerCall(mockTargetSpecific, value, payload));
        builder.addCall(RipplerCall(mockTargetSpecific, value, payload));
        builder.addCall(RipplerCall(mockTargetSpecific, value, payload));
        builder.addCall(RipplerCall(mockTargetSpecific, value, payload));
        builder.addCall(RipplerCall(mockTargetSpecific, value, payload));
        builder.addCall(RipplerCall(mockTargetSpecific, value, payload));
        builder.addCall(RipplerCall(mockTargetSpecific, value, payload));
        builder.addCall(RipplerCall(mockTargetSpecific, value, payload));
        builder.addCall(RipplerCall(mockTargetSpecific, value, payload));
        builder.addCall(RipplerCall(mockTargetSpecific, value, payload));
        builder.addCall(RipplerCall(mockTargetSpecific, value, payload));
        builder.addCall(RipplerCall(mockTargetSpecific, value, payload));
        builder.addCall(RipplerCall(mockTargetSpecific, value, payload));
        builder.addCall(RipplerCall(mockTargetSpecific, value, payload));
        builder.addCall(RipplerCall(mockTargetSpecific, value, payload));

        (bool succ, bytes memory ret) = theRippler.call{ value: value * 16 }(builder.build());

        assertTrue(succ);
        assertEq(ret.length, 0);
    }

    function testFuzzRipplerCalls(RipplerCall[] memory rCalls, uint128 balance) public asActor(alice) {
        vm.assume(rCalls.length != 0);
        vm.deal(alice, balance);

        if (rCalls.length > 16) {
            vm.expectRevert("LibRippler::addCall: too many calls");
        }

        uint256 totalValue = 0;
        RipplerCallBuilder memory builder = LibRippler.newBuilder();
        for (uint256 i = 0; i < rCalls.length; i++) {
            rCalls[i].target = mockTargetFallback;
            totalValue += rCalls[i].value;
            builder.addCall(rCalls[i]);
        }

        if (totalValue <= balance) {
            for (uint256 i = 0; i < rCalls.length; i++) {
                vm.expectCall(mockTargetFallback, rCalls[i].value, rCalls[i].data);
            }
        }

        (bool succ, bytes memory ret) = theRippler.call{ value: balance }(builder.build());
        assertEq(succ, true);
        assertEq(ret.length, 0);
    }
}
