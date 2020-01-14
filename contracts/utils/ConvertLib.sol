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

	function convert(uint256 amount, address inputContract, address outputContract) public pure returns (uint256 convertedAmount) {
		// TODO Oracle data feeds for price - MULTIPLY BY 100 FOR INT, HANDLE address(0) MEANS ETH
		uint256 priceInputETH = 10;
		uint256 priceOutputETH = 5;
		return (priceInputETH / priceOutputETH) * amount;
	}

	// Creates a Chainlink request with the uint256 multiplier job
	function requestPriceInETH(string symbol, address _oracle, bytes32 _jobId, uint256 _payment) public onlyOwner {
		// newRequest takes a JobID, a callback address, and callback function as input
		Chainlink.Request memory req = buildChainlinkRequest(_jobId, this, this.fulfill.selector);
		// Adds a URL with the key "get" to the request parameters
		req.add("get", "https://min-api.cryptocompare.com/data/price?fsym=" + symbol + "&tsyms=ETH");
		// Uses input param (dot-delimited string) as the "path" in the request parameters
		req.add("path", "ETH");
		// Adds an integer with the key "times" to the request parameters
		req.addInt("times", 1000000000000000000);
		// Sends the request with the amount of payment specified to the oracle
		sendChainlinkRequestTo(_oracle, req, _payment);
	}

	// Use recordChainlinkFulfillment to ensure only the requesting oracle can fulfill. Outputs uint256.
	function fulfill(bytes32 _requestId, uint256 _price) public recordChainlinkFulfillment(_requestId) {
		currentPrice = _price;
	}

	// withdrawLink allows the owner to withdraw any extra LINK on the contract
	function withdrawLink() public onlyOwner {
		LinkTokenInterface link = LinkTokenInterface(chainlinkTokenAddress());
		require(link.transfer(msg.sender, link.balanceOf(address(this))), "Unable to transfer");
	}

	modifier onlyOwner() {
		require(msg.sender == owner, "Message sender must be contract owner");
		_;
	}
}
