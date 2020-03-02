// Converts tokens 1:1 and cents to tokens 1:1. For true oracle implementation see ConvertLibChainlink.sol.

pragma solidity ^0.5.0;

contract ConvertLib {

	address public owner;

	// Converts the amount in one token to another.
	function convert(uint256 amount, address inputContractAddress, address outputContractAddress) public pure returns (uint256 convertedAmount) {
		return amount;
	}

	// Returns the number of tokens for a given USD input.
	function usdToTokens(uint256 amountInCents, address inputContractAddress) public pure returns (uint256 price) {
		return amountInCents;
	}

	modifier onlyOwner() {
		require(msg.sender == owner, "Message sender must be contract owner");
		_;
	}
}
