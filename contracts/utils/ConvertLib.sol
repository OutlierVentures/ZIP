pragma solidity ^0.5.0;

import "../../node_modules/chainlink/contracts/ChainlinkClient.sol";

contract ConvertLib is ChainlinkClient {

	constructor(address _link) public {
		// Set the address for the LINK token for the network.
		if(_link == address(0)) {
		// Useful for deploying to public networks.
		setPublicChainlinkToken();
		} else {
		// Useful if you're deploying to a local network.
		setChainlinkToken(_link);
		}
	}

	function convert(uint256 amount, address inputContract, address outputContract) public pure returns (uint256 convertedAmount)
	{
		// TODO Oracle data feeds for price - MULTIPLY BY 100 FOR INT, HANDLE address(0) MEANS ETH
		uint256 priceInputETH = 10;
		uint256 priceOutputETH = 5;
		return (priceInputETH / priceOutputETH) * amount;
	}
}
