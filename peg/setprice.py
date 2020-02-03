import pandas as pd

class SetPrice:

    def get_data(self):
        gas_limit = pd.read_csv("https://etherscan.io/chart/gaslimit?output=csv", index_col = 0)
        gas_price = pd.read_csv("https://etherscan.io/chart/gasprice?output=csv", index_col = 0)
        eth_price = pd.read_csv("https://etherscan.io/chart/etherprice?output=csv", index_col = 0)
        gas_limit = gas_limit.drop('UnixTimeStamp', 1)
        gas_price = gas_price.drop('UnixTimeStamp', 1)
        eth_price = eth_price.drop('UnixTimeStamp', 1)
        gas_price = gas_price.rename(columns = {'Value (Wei)': 'Value'})
        self.gas_limit = gas_limit
        self.gas_price = gas_price
        self.eth_price = eth_price

    
