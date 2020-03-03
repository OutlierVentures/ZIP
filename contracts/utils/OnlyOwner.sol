pragma solidity ^0.5.0;

/**
* @dev Modifier for functions only the contract owner can use,
* including core owner-only logic.
*/
contract OnlyOwner {

    address public contractOwner;
    uint256 public _minEthBalance;

    /**
     * @dev Modifier for functions callable only by the contract owner.
     * Not eligible for relayed calls.
     */
    modifier onlyOwner() {
		require(msg.sender == contractOwner, "Message sender must be contract owner");
		_;
	}

    /**
     * @dev Set the minimumEthBalance of the contract to cover gas.
     * Not eligible for relayed calls.
     */
    function setMinEthBalance(uint256 amount) public onlyOwner {
        _minEthBalance = amount;
    }

}