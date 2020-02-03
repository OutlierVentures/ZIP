import pandas as pd

class SetPrice:

    def __init__(self, gas_limit_url, gas_price_url, token_price_url, operation_gas_cost):
        self.gas_limit_url = gas_limit_url
        self.gas_price_url = gas_price_url
        self.token_price_url = token_price_url
        self.operation_gas_cost = operation_gas_cost

    def get_data(self):
        gas_limit = pd.read_csv("https://etherscan.io/chart/gaslimit?output=csv", index_col = 0)
        gas_price = pd.read_csv("https://etherscan.io/chart/gasprice?output=csv", index_col = 0)
        eth_price = pd.read_csv("https://etherscan.io/chart/etherprice?output=csv", index_col = 0)
        gas_limit = gas_limit.drop('UnixTimeStamp', 1)
        gas_price = gas_price.drop('UnixTimeStamp', 1)
        eth_price = eth_price.drop('UnixTimeStamp', 1)
        gas_price = gas_price.rename(columns = {'Value (Wei)': 'Value'})
        return gas_limit, gas_price, eth_price

    def pricing_usd(self, gas_limit, gas_price, eth_price):
        gas_price_eth = gas_price.div(1000000000000000000) # Wei to eth
        gas_price_usd = gas_price_eth * eth_price
        operation_price_usd = gas_price_usd * self.operation_gas_cost
        return operation_price_usd
    
    
