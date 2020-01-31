import pandas as pd, matplotlib.pyplot as plt

gas_limit = pd.read_csv('gaslimit.csv', index_col = 0)
gas_price = pd.read_csv('gasprice.csv', index_col = 0)
eth_price = pd.read_csv('ethprice.csv', index_col = 0)
block_time = pd.read_csv('ethprice.csv', index_col = 0)
gas_limit = gas_limit.drop('UnixTimeStamp', 1)
gas_price = gas_price.drop('UnixTimeStamp', 1)
gas_price = gas_price.rename(columns = {'Value (Wei)': 'Value'})
eth_price = eth_price.drop('UnixTimeStamp', 1)
block_time = block_time.drop('UnixTimeStamp', 1)

operation_gas_cost = 3

gas_price_eth = gas_price.div(1000000000000000000)
gas_price_usd = gas_price_eth * eth_price
operation_price_usd = gas_price_usd * operation_gas_cost
ops_sec_usd = operation_price_usd / block_time

eth_price_six_mo = eth_price[-182:]
norm_eth_price = (eth_price_six_mo - eth_price_six_mo.min()) / (eth_price_six_mo.max() - eth_price_six_mo.min())
norm_eth_price = norm_eth_price.rename(columns = {'Value': 'ETH price (normalised)'})

op_price_six_mo = operation_price_usd[-182:]
norm_op_price = (op_price_six_mo - op_price_six_mo.min()) / (op_price_six_mo.max() - op_price_six_mo.min())
norm_op_price = norm_op_price.rename(columns = {'Value': 'Operation price (normalised)'})

op_sec_usd_six_mo = ops_sec_usd[-182:]
norm_op_sec_usd = (op_sec_usd_six_mo - op_sec_usd_six_mo.min()) / (op_sec_usd_six_mo.max() - op_sec_usd_six_mo.min())
norm_op_sec_usd = norm_op_sec_usd.rename(columns = {'Value': 'Ops/sec price (normalised)'})

merged = operation_price_usd[-182:]#pd.concat([norm_eth_price, norm_op_price], axis = 1)
merged = merged.rename(columns = {'Value': 'Operation price (USD)'})
merged.index = merged.index.str.replace('/2019', '').str.replace('/2020', '')
merged.plot()
plt.savefig('hist.png')



#ops_per_block = gas_limit / operation_gas_cost

# Plot step function for pricing
def highs_vs_means(operation_price_usd: pd.DataFrame, period: int):
    num_prices = len(operation_price_usd)
    num_periods = int(num_prices / period)
    means = []
    tops = []
    for i in range(num_periods):
        index_start = i * period
        window = operation_price_usd["Value"][index_start:(index_start + period)]
        for _ in range(period):
            means.append(sum(window) / period)
            tops.append(window.max())
    means_tops = pd.DataFrame({'Mean': means, 'Price': tops}, index = operation_price_usd.index)
    operation_price_usd = operation_price_usd.rename(columns = {'Value': 'Operation price (USD)'})
    merged = pd.concat([operation_price_usd, means_tops], axis = 1)
    merged.index = merged.index.str.replace('/2019', '').str.replace('/2020', '')
    merged.plot()
    plt.savefig('pricing.png')

highs_vs_means(operation_price_usd[-182:], 7)