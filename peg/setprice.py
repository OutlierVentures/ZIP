import itertools, requests, pandas as pd, matplotlib.pyplot as plt
from io import StringIO

class SetPrice:

    def __init__(self, gas_limit_url: str, gas_price_url: str, token_price_url: str, gas_used_url: str, num_tx_url: str, operation_gas_cost: int):
        self.gas_limit_url = gas_limit_url
        self.gas_price_url = gas_price_url
        self.token_price_url = token_price_url
        self.gas_used_url = gas_used_url
        self.num_tx_url = num_tx_url
        self.operation_gas_cost = operation_gas_cost

    def show_pricing(self):
        gas_limit, gas_price, eth_price, gas_used, num_tx = self.get_data()
        operation_price_usd = self.pricing_usd(gas_limit, gas_price, eth_price)
        self.highs_vs_means(operation_price_usd, 90, gas_used, num_tx) # 90 for quarterly       

    def get_data(self):
        headers = {"User-Agent": "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/56.0.2924.76 Safari/537.36"}
        gl = requests.get(self.gas_limit_url, headers = headers).text
        gp = requests.get(self.gas_price_url, headers = headers).text
        ep = requests.get(self.token_price_url, headers = headers).text
        gu = requests.get(self.gas_used_url, headers = headers).text
        nt = requests.get(self.num_tx_url, headers = headers).text
        gas_limit = pd.read_csv(StringIO(gl), sep = ",", index_col = 0)
        gas_price = pd.read_csv(StringIO(gp), sep = ",", index_col = 0)
        eth_price = pd.read_csv(StringIO(ep), sep = ",", index_col = 0)
        gas_used = pd.read_csv(StringIO(gu), sep = ",", index_col = 0)
        num_tx = pd.read_csv(StringIO(nt), sep = ",", index_col = 0)
        gas_limit = gas_limit.drop("UnixTimeStamp", 1)
        gas_price = gas_price.drop("UnixTimeStamp", 1)
        eth_price = eth_price.drop("UnixTimeStamp", 1)
        gas_used = gas_used.drop("UnixTimeStamp", 1)
        num_tx = num_tx.drop("UnixTimeStamp", 1)
        gas_price = gas_price.rename(columns = {"Value (Wei)": "Value"})
        return gas_limit, gas_price, eth_price, gas_used, num_tx

    def pricing_usd(self, gas_limit: pd.DataFrame, gas_price: pd.DataFrame, eth_price: pd.DataFrame):
        gas_price_eth = gas_price.div(1000000000000000000) # Wei to eth
        gas_price_usd = gas_price_eth * eth_price
        operation_price_usd = gas_price_usd * self.operation_gas_cost
        return operation_price_usd
    
    def highs_vs_means(self, operation_price_usd: pd.DataFrame, period: int, gas_used: pd.DataFrame, num_tx: pd.DataFrame):
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
                forecasted_mean = ((mean + means[-1]) / 2)
                forecasted_top = (top + tops[-1]) / 2
                forecasted_means.append(forecasted_mean)
                forecasted_tops.append(forecasted_top)
            means.append(mean)
            tops.append(top)
        forecasted_means = self.repeat_list_item(forecasted_means, period)[:-period] # What we cut off is next quarter"s pricing
        forecasted_tops = self.repeat_list_item(forecasted_tops, period)[:-period]
        forecasted_means_tops = pd.DataFrame({"FUEL pricing": forecasted_means}, index = operation_price_usd.index)

        pricing = forecasted_means_tops.rename(columns = {"FUEL pricing": "Value"})
        margin = pricing - operation_price_usd
        margin = margin[180:]
        print(margin)
        num_used_ops = gas_used[-len(margin):] / self.operation_gas_cost
        used_ops_per_tx = num_used_ops / num_tx[-len(margin):]
        print(used_ops_per_tx)
        margin = margin * used_ops_per_tx
        print(sum(margin['Value']) / len(margin['Value']))

        operation_price_usd = operation_price_usd.rename(columns = {"Value": "Operation price (USD)"})
        merged = pd.concat([operation_price_usd, forecasted_means_tops], axis = 1)
        merged.index = merged.index.str.replace("/20", "/")
        merged = merged[180:]
        plt.style.use('dark_background')
        merged.plot()
        plt.savefig("pricing.png")

    # ([1,2], 3) -> [1,1,1,2,2,2]
    def repeat_list_item(self, lst: list, n: int):
        return list(itertools.chain.from_iterable(itertools.repeat(x, n) for x in lst))


if __name__ == "__main__":
    sp = SetPrice("https://etherscan.io/chart/gaslimit?output=csv", "https://etherscan.io/chart/gasprice?output=csv", "https://etherscan.io/chart/etherprice?output=csv", "https://etherscan.io/chart/gasused?output=csv", "https://etherscan.io/chart/tx?output=csv", 3)
    sp.show_pricing()