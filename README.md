## The Rippler

A Fast as Fuck Mutlicaller.

The Rippler removes Turing Completeness as a gas optimization, interpreting the first 2 bytes of
calldata as one of 16 jump targets, then running each call in reverse order. Call results are
neither checked nor popped, they remain on the stack at the time of halting.

### Warnings

- The Rippler does not check for reverts
- Encoding MUST contain 2 byte prefix to the proper jumpdest
- Calls MUST be encoded in revese order
- The Rippler uses EVM version Shanghai
- Modifications to The Rippler may invalidate the jumpdest table

### Relevant Software

- [The Rippler Huff Source Code](src/TheRippler.huff)
- [The Periphery Contract Source Code](src/ThePeriphery.sol)
- [The Library with Relevant Types and Encoders](src/util/LibRippler.sol)

### Encoding Specification

```
<encoding> ::=
    <call_count_jumpdest>
    (<target> <value> <argumgnet_ptr> <argument_length>)+
    (<payload>)+
```

The `<call_count_jumpdest>` is a `uint16` jump target indicating the number of calls to make.

| call count | jumpdest |
| ---------- | -------- |
| 1          | 0x0006   |
| 2          | 0x002b   |
| 3          | 0x0050   |
| 4          | 0x0075   |
| 5          | 0x009a   |
| 6          | 0x00bf   |
| 7          | 0x00e4   |
| 8          | 0x0109   |
| 9          | 0x012e   |
| 10         | 0x0153   |
| 11         | 0x0178   |
| 12         | 0x019b   |
| 13         | 0x01bc   |
| 14         | 0x01dd   |
| 15         | 0x01fe   |
| 16         | 0x021f   |

The `<target>` is a 160 bit address, `<value>` is a 128 bit wei value, `<argument_ptr>` is a 32 bit
pointer to the payload, `<argument_length>` is a 32 bit length of the payload, and `<payload>` is an
unstructured byte array.

### Gas Metering

```
forge t --mc GasMetering -vvv
```

![Graph Comparing TheRippler to Multicall3](assets/TheRipplerVsMulticall3.svg)

```
MulticallGasMetering::test01: 44791
MulticallGasMetering::test02: 60443
MulticallGasMetering::test03: 76099
MulticallGasMetering::test04: 91755
MulticallGasMetering::test05: 107387
MulticallGasMetering::test06: 123055
MulticallGasMetering::test07: 138700
MulticallGasMetering::test08: 154368
MulticallGasMetering::test09: 170025
MulticallGasMetering::test10: 185682
MulticallGasMetering::test11: 201339
MulticallGasMetering::test12: 216997
MulticallGasMetering::test13: 232630
MulticallGasMetering::test14: 248300
MulticallGasMetering::test15: 263934
MulticallGasMetering::test16: 279592
TheRipplerGasMetering::test01: 41695
TheRipplerGasMetering::test02: 52294
TheRipplerGasMetering::test03: 62917
TheRipplerGasMetering::test04: 73528
TheRipplerGasMetering::test05: 84127
TheRipplerGasMetering::test06: 94750
TheRipplerGasMetering::test07: 105361
TheRipplerGasMetering::test08: 115972
TheRipplerGasMetering::test09: 126583
TheRipplerGasMetering::test10: 137182
TheRipplerGasMetering::test11: 147793
TheRipplerGasMetering::test12: 158404
TheRipplerGasMetering::test13: 169003
TheRipplerGasMetering::test14: 179614
TheRipplerGasMetering::test15: 190213
TheRipplerGasMetering::test16: 200824
```
