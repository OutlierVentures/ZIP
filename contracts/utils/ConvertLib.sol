pragma solidity ^0.5.0;

library ConvertLib{
	function convert(uint256 amount, address inputContract, address outputContract) public pure returns (uint256 convertedAmount)
	{
		// TODO Oracle data feeds for price - MULTIPLY BY 100 FOR INT, HANDLE address(0) MEANS ETH
		uint256 priceInputETH = 10;
		uint256 priceOutputETH = 5;
		return (priceInputETH / priceOutputETH) * amount;
	}
}
