# Actor Mapping

1. Developers
    1. Indviduals
    2. Dev teams
        1. Web 2
            1. Independent
            2. Enterprise
        2. Web 3
            1. Independent
                1. Protocol-agnostic
                2. Tribal
            2. Enterprise
2. Enterprises
    1. Blockchain as a service / product (capital-generation)
        1. SME
        2. Large enterprise
    2. Blockchain for operations (cost-saving)
        1. SME
        2. Large enterprise
3. Consumers
    1. Innovators
    2. Early adopters
    3. Early majority
    4. Late majority
    5. Laggards
4. Investors
    1. Crypto-native
        1. Funds
        2. Private
    2. Non crypto-native
        1. Funds
        2. Private
        3. Institutional
5. Exchanges
    1. Centralised
        1. FIAT gateway
        2. Non-FIAT gateway
    2. Decentralised
6. Networks
    1. Tokenised
        1. Blockchain-native gas
        2. App layer (ERC20-like)
    2. Non-tokenised
7. Network participants
    1. Node operators
        1. Individuals
        2. Service providers
    2. Stakers
        1. Market-layer participants (e.g. staking pools / Lunie)
        2. Ledger-layer participants (e.g. Chorus One)
8. Regulators
    1. Non-US
    2. US

## Value Exchange Map

### Direct interactions

Consumers, investors and developers interact directly with the CStack. Value exchanges:

1. Money in from consumers in exchange for convenience.
2. Money in from developers in exchange for convenience.
3. Money in from and out to investors speculating on the price of compute.

### Indirect interactions

Enterprises interact indirectly with the CStack through developers. Value exchange:

1. Money in to developers from enterprises in exchange for cost-saving and/or revenue generation opportunities.

Consumers interact (doubly) indirectly with the CStack through enterprises. Value exchange:

1. Money in to enterprises from consumers in exchange for convenience.

### Motivating the value exchange

1. Convenience for consumers:
    1. FIAT abstraction of tokens, useable across networks (FIAT gateway + meta-token + simple wallet interface).
    2. Consumer-focused Stack benefits: self-sovereign identity, cheap cross-border remittance, privacy-preserving voice assistants, tipping creators etc.
2. Convenience for developers:
    1. FIAT abstraction of tokens, useable across networks (FIAT gateway + meta-token + simple wallet interface).
    2. Developer-focused Stack benefits: private compute, decentralised databases, data marketplaces etc.
3. The CStack needs to act as a speculative instrument for investors.
4. The Cstack needs to make it easy for developers to create cost-saving and/or revenue generation opportunities for enterprises.
5. The Cstack needs to make it easy for enterprises to create convenience for consumers.

## Futures market value map

1. A speculator would lock up tokens in a smart contract, given a specified gas limit and price*.
2. The speculator can create new stable crypto commodities (SCC) known as FUEL as liabilities against their collateral up to a threshold.
3. FUEL (representing prepaid network gas*) is sold to developers for fiat - *leveraging the speculator’s position with fiat*. Tokens are not locked up until FUEL is bought.
4. The FUEL price target is provided by an oracle*, with the target maintained by a dynamic FUEL supply.
    1. FUEL is pegged to certain amount of compute (eg. X FLOPS).
    2. If price is above target, speculators have an incentive to create new FUEL and sell at a ‘premium’ price.
    3. If price is below target, speculators have incentive to repurchase FUEL (reduce supply) to decrease their leverage at a discount.

## Infrastructure mapping

1. Basket pair trading:
    1. Uniswap - 0.3% fee
    2. Chainlink / Oraclize - token costs equating to approx $0.50 per swap (2 x $0.25 per query)
2. Token standards:
    1. OpenZeppelin ERC20
    2. ConsenSys ERC20
    3. Fetch FetchNative-ERC20
3. Gas containerisation
    1. GasToken - storage refund exploit
4. Native token in wallet requirement removal
    1. Gas Stations Network
        1. OpenZeppelin implementation
        2. Portis implementation
5. Futures contracts
    1. VollgasDAO - Ethereum gas futures
