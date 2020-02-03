import itertools, requests, pandas as pd, matplotlib.pyplot as plt
from io import StringIO

class SetPrice:

    def __init__(self, gas_limit_url, gas_price_url, token_price_url, operation_gas_cost):
        self.gas_limit_url = gas_limit_url
        self.gas_price_url = gas_price_url
        self.token_price_url = token_price_url
        self.operation_gas_cost = operation_gas_cost

    def show_pricing(self):
        gas_limit, gas_price, eth_price = self.get_data()
        operation_price_usd = self.pricing_usd(gas_limit, gas_price, eth_price)
        self.highs_vs_means(operation_price_usd, 90)        

    def get_data(self):
        headers = {'User-Agent': 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/56.0.2924.76 Safari/537.36'}
        gl = requests.get("https://etherscan.io/chart/gaslimit?output=csv", headers = headers).text
        gp = requests.get("https://etherscan.io/chart/gasprice?output=csv", headers = headers).text
        ep = requests.get("https://etherscan.io/chart/etherprice?output=csv", headers = headers).text
        gas_limit = pd.read_csv(StringIO(gl), sep=",", index_col = 0)
        gas_price = pd.read_csv(StringIO(gp), sep=",", index_col = 0)
        eth_price = pd.read_csv(StringIO(ep), sep=",", index_col = 0)
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
    
    def highs_vs_means(self, operation_price_usd: pd.DataFrame, period: int):
        operation_price_usd = operation_price_usd[-(10 * period):]
        num_prices = len(operation_price_usd)
        num_periods = int(num_prices / period)
        means = []
        tops = []
        forecasted_means = [0, 0]
        forecasted_tops = [0, 0]
        for i in range(num_periods):
            index_start = i * period
            window = operation_price_usd["Value"][index_start:(index_start + period)]
            mean = sum(window) / period
            top = window.max()
            """
            for _ in range(period):
                # Repeat period times so we can plot all points as a line over the true data
                means.append(sum(window) / period)
                tops.append(window.max())
            """
            if i:
                forecasted_mean = (mean + means[-1]) / 2
                forecasted_top = (top + tops[-1]) / 2
                forecasted_means.append(forecasted_mean)
                forecasted_tops.append(forecasted_top)
            means.append(mean)
            tops.append(top)
        forecasted_means = self.repeat_list_item(forecasted_means, period)[:-period]
        forecasted_tops = self.repeat_list_item(forecasted_tops, period)[:-period]
        forecasted_means_tops = pd.DataFrame({'Mean': forecasted_means, 'Price': forecasted_tops}, index = operation_price_usd.index)
        operation_price_usd = operation_price_usd.rename(columns = {'Value': 'Operation price (USD)'})
        merged = pd.concat([operation_price_usd, forecasted_means_tops], axis = 1)
        merged.index = merged.index.str.replace('/2019', '').str.replace('/2020', '')
        merged.plot()
        plt.savefig('pricing.png')

    # ([1,2], 3) -> [1,1,1,2,2,2]
    def repeat_list_item(self, lst, n):
        return list(itertools.chain.from_iterable(itertools.repeat(x, n) for x in lst))


if __name__ == "__main__":
    sp = SetPrice("https://etherscan.io/chart/gaslimit?output=csv", "https://etherscan.io/chart/gasprice?output=csv", "https://etherscan.io/chart/etherprice?output=csv", 3)
    sp.show_pricing()