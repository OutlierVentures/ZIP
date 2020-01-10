# Stable Token

Gas futures market for stable gas.

## Install

```sh
npm i -g truffle
```

## Deploy contracts

```sh
truffle compile
truffle migrate
```

## Problem statement

To lower the barriers of adoption for creating and operating applications using multiple technologies in the CStack.  

Barriers to adoption and UX issues, in order of importance:

1. Complexity and friction of acquiring and managing multiple tokens.
2. Ledger cost volatility (gas costs).
3. Utility price volatility.

## Intended solution

1. A meta-token redeemed for the relevant underlying token through smart contracts and the time of executing ledger operations.
2. A smart contract-based gas futures market to stabilise the cost of fees.
3. A fiat gateway/abstraction layer hiding the token cost, which ultimately should not be stabilised for the sake of investability.

Note that token and gas price are not inherently correlated, only network congestion (which raises gas costs) tends to occur at the same time as token price increases due to increased trading volume. Stabilising gas costs will not stabilise token costs and vice versa.

