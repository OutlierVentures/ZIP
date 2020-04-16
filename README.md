<p align="center">
    <img src="./docs/zip-header.png" />
    <br><br>
    <a href="#" alt="Cross-chain">
        <img src="./docs/xchain.svg" />
    </a>
    <a href="#" alt="Stable">
        <img src="./docs/stable.svg" />
    </a>
    <a href="https://outlierventures.io" alt="Convergence ready">
        <img src="./docs/convergence.svg" />
    </a>
    <br><br>
    Blockchain cloud credits: a cross-chain stable token.<br><br>
    <i>An Outlier Ventures project.</i>
</p>


## Install

Requires Node.JS and Python.

```sh
pip3 install pandas matplotlib
npm i -g truffle
npm i @openzeppelin/contracts-ethereum-package @openzeppelin/upgrades
```

## Deploy contracts

```sh
truffle compile
truffle migrate
```

## Using Z!P

If you've got Zip in your wallet, just bring up the Zip interface and call redeem with your chosen chain and your dapp's address on that chain. For example, to use 100 units on Fetch.AI:

```js
Interface zip = Interface("0xZIPCONTRACTADDRESS");
zip.redeem("FET", 100, "0xYOURCONTRACTFETCHADDRESS");
```

Note that Z!P is not yet a live token, and you'll need to deploy it. The code has been written for you, including a UI: see Demo Dapp below.

## Problem statement

To lower the barriers of adoption for creating and operating applications using multiple blockchain networks.  

Barriers to adoption and UX issues, in order of importance:

1. Complexity and friction of acquiring and managing multiple tokens.
2. Ledger cost volatility (gas costs).
3. Utility price volatility.

## The Z!P solution

1. A meta-token redeemed for the relevant underlying token through smart contracts and the time of executing ledger operations.
2. A stable pricing model according to usage rather than the USD.

<p align="center">
    <img src="./docs/overview.png" width="400" />
</p>

Note that token and gas price are not inherently correlated, only network congestion (which raises gas costs) tends to occur at the same time as token price increases due to increased trading volume. Stabilising gas costs will not stabilise token costs and vice versa.

## Z!P functionality

Z!P is an ERC20-compliant token based largely on the OpenZeppelin reference for Solidity 0.5. It is a mint/burn model backed by a collateral pool of tokens.

Z!P's collateral pool is a basket of tokens which may be used to pay for network fees, as well as ETH to cover gas. At any time, anyone may spend Z!P as if it were their chosen underlying token (specified by that token's symbol) through a token allowance model. The deposited Z!P is converted to the underlying tokens according to their market value in ETH. This price feed is achieved using an oracle. Similarly, underlying tokens may be deposited in the contract, minting Z!P at the market rate for the depositor. Minimum token balances are required for mint/burn calls, and setting these minimum balances is only available to the contract owner (the value may be voted on using off-chain governance).

<p align="center">
    <img src="./docs/depositwithdraw.png" width="800" />
</p>

### Cross-chain redemption

The user simply specifies their dapp's address on the non-Ethereum networks in a Solidity function call, and the back-end handles the ledger payment:

```js
zip.redeem("FET", 100, "0xYOURCONTRACTFETCHADDRESS");
```

Cross-chain redemption is achieved via _migration contracts_. This is a set of smart contracts which lock an asset on one chain, and release a second asset on another. The locking contract emits an _event_ to be picked up by an open-source off-chain listener, which submits the release transaction on the other chain. Use of migration contracts has two key benefits. First, several major chains have live migrations, allowing ZIP to utilise existing infrastructure. Second, support for chains can be built while the ZIP token is live: on-chain logic may be set in stone (consisting of a function call specifying a locking contract address and the amount to redeem). The locking contract and external-chain redemption contract can be developed and deployed at any time, without the need to change the already deployed ZIP code.

Z!P is also Gas Stations Network-compatible, meaning only Z!P token is needed by developers, not ETH and Z!P as would typically be the case.

Z!P thereby becomes an ERC20 token which may be used across blockchain networks.

#### Reducing latency

Latency is to be reduced as per [Issue 1](https://github.com/OutlierVentures/ZIP/issues/1).

One problem with Z!P's current implementation is increased latency versus native function calls. Right now, `redeem()` grants an allowance to the migration contract, which emits the relevant _event_ only once it has seen the allowance. The off-chain listener then submits the function call on the non-Ethereum chain.

This latency could be significantly reduced by emitting the event at `redeem()` call time, and locking the tokens in this function call.

The problem with this approach is that existing migration contracts will still need to be supported (i.e. the current implementation), and Z!P contract logic cannot be changed once deployed.

The solution: a `mapping(string => address) public highspeedMigrations` (e.g. `TOK,0xTOKCONTRACTADDRESS`) with a get/set that writes newly implemented migrations to the contract state, that can the be checked for membership. Then (pseudocode):
```js
if (highspeedMigrations(chosenChain) != address(0)) {
    Interface(highspeedMigrations(chosenChain)).transfer(`0xESCROWADDRESS`, AMOUNT) // Send on to brun address once tx confirmed on other chain
    emit Redemption(redeemer, chain, amount);
} else {
    // Transfer/allowance to existing migration contract as normal
}
```

A refund mechanism for escrowed funds will also need to be implemented for failed or stuck redemptions, should these occur.

### Stable pricing

The stable pricing model applies a flat price updated quarterly (in development, see the `peg` folder). Deposits and withdrawals currently implement a 2.5% fee to cover gas costs and external token costs as an interim solution.

<p align="center">
    <img src="./docs/pricing.png" width="500" />
</p>

### Demo Dapp

There is a demo dapp in the demo folder. By default, this uses test RPC (node needs to be running); to use it on test/mainnet, deploy the dapp contract and Z!P contract to your net of choice. The demo dapp has two components:

1. `deployZIP`: Move Z!P around addresses. Send some to your wallet for use in the dapp.
2. `demoDapp`: A dapp with a button that when pressed, transfers 100 Z!P to the dapp (normal metamask signing), and the dapp then spends it on FET.

### A note on using futures to stabilise gas

A futures market can be used as an alternate stabilisation mechanism. See `contracts/futures` for exploratory work. There are two options for stabilising gas using a futures market:

1. Accrual of gas itself through a refund exploit mechanism, as with [GasToken](https://github.com/projectchicago/gastoken). The gas is locked at the time of the futures contract's inception.
2. A right to gas token which may be redeemed for gas at the time of transaction execution by liquidating the funds locked in a futures contract (e.g. ETH).

The former is tried and tested, but relies on the ability to exploit refund mechanisms, which may be impossible on certain chains. The latter is inherently cross-chain compatible (by purchasing the relevant native chain token using the right to gas token, then using the native chain token to pay for gas). Notably, the second option also introduces significant transaction delay (on average doubling transaction time, assuming no exchange delay) as well as requires an actively traded token pair to function.

<p align="center">
    <img src="./docs/futures.png" width="800" />
</p>

Ultimately, a price peg (updated quarterly) as discussed above is a more viable solution.

## The benefits: without Z!P vs with Z!P

### Without Z!P

1. User wants to use network X.
2. User goes to an exchange and purchases token X.
3. User transfers token X to their wallet and waits for them to arrive.
4. User purchases a compute job on network X using token X.
5. User wants to use network Y.
6. User goes to an exchange and purchases token Y.
7. User transfers token Y to their wallet and waits for them to arrive.
8. User purchases a compute job on network Y using token Y.
9. User wants to use network Z.
10. User goes to an exchange and purchases token Z.
11. User transfers token Z to their wallet and waits for them to arrive.
12. User purchases a compute job on network Z using token Z.
...

In other words, the user needs to purchase a separate token and transfer it to their wallet every time they want to use a given network. They have to know the correct token to buy and where to buy it (which often differs depending on network). They also rack up significant gas fees and time cost.

### With Z!P

1. User purchases Z!P.
2. User uses Z!P on any of the underlying networks like a prepaid card.

A further benefit of the CStack token is that it may be purchased both as normal on an exchange, but may also be acquired by depositing any of the underlying tokens in exchange for the CStack token - no exchanges needed.

## Roadmap: next up

1. [Reduced latency in cross-chain redemption](https://github.com/OutlierVentures/ZIP/issues/1).
2. GSN tests (see [OpenZeppelin](https://github.com/OpenZeppelin/openzeppelin-contracts/tree/master/test/GSN)).
