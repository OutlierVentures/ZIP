import pandas as pd

class SetPrice:

    def get_data(self):
        self.gas_limit = pd.read_csv("https://etherscan.io/chart/gaslimit?output=csv")
        self.gas_price = pd.read_csv("https://etherscan.io/chart/gasprice?output=csv")
        self.eth_price = pd.read_csv("https://etherscan.io/chart/etherprice?output=csv")