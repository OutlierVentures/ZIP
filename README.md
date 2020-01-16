# CStack Token

A single token to use across the stack and a gas futures market for stable gas.

## Install

```sh
npm i
```

If you don't have truffle installed globally, install it: `npm i -g truffle`

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

1. A super-token redeemed for the relevant underlying token through smart contracts and the time of executing ledger operations.
2. A smart contract-based gas futures market to stabilise the cost of fees.
3. A fiat gateway/abstraction layer hiding the token cost, which ultimately should not be stabilised for the sake of investability.

Note that token and gas price are not inherently correlated, only network congestion (which raises gas costs) tends to occur at the same time as token price increases due to increased trading volume. Stabilising gas costs will not stabilise token costs and vice versa.

## Supertoken functionality

The Supertoken is an ERC20-compliant token based largely on the OpenZeppelin reference for Solidity 0.5. It is a mint/burn model backed by a basket of tokens.

The Supertoken is a basket of tokens which may be used to pay for network fees, as well as ETH to cover gas. At any time, anyone may redeem Supertokens for their chosen underlying token specified by that token's contract address. The deposited Supertokens are converted to the underlying tokens according to their market value in ETH. This price feed is achieved using Chainlink oracles. Similarly, underlying tokens may be deposited in the contract, minting Supertokens at the market rate for the depositor. Minimum token balances are required for mint/burn calls, and setting these minimum balances is only available to the contract owner (the value may be voted on using off-chain governance).

The Supertoken thereby becomes an ERC20 token which may be used across any of the underlying networks by simply specifying the network at transaction time.

### Gas Stations Network addition

The default Supertoken design is that users interact with any token in the stack using the Supertoken, but also have Ether in their wallet to cover the fees. This may be circumvented by implementing Gas Stations Network, however this significantly increases the complexity of the project, notably:

1. Gas Stations Network will need be to implemented for transactions after the Supertoken -> base swap takes place.
2. Token pool management and monetary policy will need to make a greater number of considerations for gas fees.

Implementing Gas Stations Network has a strong advantage in differentiating the project from Uniswap at the Ethhereum token level.

## Gas stabilisation mechanism options

There are two options for stabilising gas using a futures market:

1. Accrual of gas itself through a refund exploit mechanism, as with [GasToken](https://github.com/projectchicago/gastoken). The gas is locked at the time of the futures contract's inception.
2. A right to gas token which may be redeemed for gas at the time of transaction execution by liquidating the funds locked in a futures contract (e.g. ETH).

The former is tried and tested, but relies on the ability to exploit refund mechanisms, which may be impossible on certain chains. The latter is inherently cross-chain compatible (by purchasing the relevant native chain token using the right to gas token, then using the native chain token to pay for gas). Notably, the second option also introduces significant transaction delay (on average doubling transaction time, assuming no exchange delay) as well as requires an actively traded token pair to function.

## Solidity vs Etch implementations

Key points:

- A meta-token for the entire CStack is better issued on Ethereum for three reasons:
    1. Interoperability with virtually all wallets, improving UX significantly.
    2. Interoperability with exchanges by default, making listings easier.
    3. Ethereum and the ERC20 standard are battle-tested, allowing for more confidence in the token's safety.
- Solidity and Etch are both equally capable of running a smart-contract based futures exchange, however interoperability for the redemption for gas component makes this better suited to Ethereum, as it natively covers 10+ tokens in the CStack rather than one.
- Price oracle data is more trusted on Ethereum through oracles such as Chain
- In the CStack, Fetch.AI is currently the most viable non-Ethereum chain to implement gas stability and redemption for.
