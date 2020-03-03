pragma solidity ^0.5.0;

contract OnlyOwner {

    address public contractOwner;

    /**
     * @dev Modifier for functions callable only by the contract owner.
     * Not eligible for relayed calls.
     */
    modifier onlyOwner() {
		require(msg.sender == contractOwner, "Message sender must be contract owner");
		_;
	}

}