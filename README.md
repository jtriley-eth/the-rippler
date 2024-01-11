## The Rippler

A Fast as Fuck Mutlicaller

### Warnings

- The Rippler does not check for reverts
- Encoding MUST contain 2 byte prefix to the proper jumpdest
- Calls MUST be encoded in revese order
- The Rippler uses EVM version Shanghai
- Modifications to The Rippler may invalidate the jumpdest table

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
