# Design

## Peg

The peg is *FLOPS/USD*.

The price of 1 FLOP will have a varying price in USD, but relatively stable, the same model as cloud services such as AWS.

To determine acceptable ranges, we need to know the historical price of FLOPS across networks. To compute this:

1. We compute the current cost of a FLOP for each network by a simple smart contract with a single FLOP operation, take the gas cost and convert to USD.
2. The cost of a FLOP is directly correlated with the price of gas on each network. Thus we take the historical price of gas across networks and average the trends, to get the historical variability.
3. We backward compute the current price of a FLOP along the trend line from step 2.
4. We determine the anticapted maximum ranges over the next chosen time period (e.g quarter), and price FLOPS in USD accordingly, updating each time period.

