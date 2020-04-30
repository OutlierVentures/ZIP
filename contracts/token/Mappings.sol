pragma solidity ^0.5.0;

import "../utils/OnlyOwner.sol";

/**
 * @dev Maps token symbols to contract and migartion addreses addresses.
 * If no contract address, not supported.
 * If no migration address, is a native swap.
 * If both a contract address and a migration address, uses an external swap.
 */
contract Mappings is OnlyOwner {
    
    struct Details {
        bool _isERC20;
        address _contractAddress;
        address _migrationAddress;
    }
    mapping(string => Details) public swapDetails;

    function getDetails(string memory symbol) public view returns (bool, address, address) {
        require(swapDetails[symbol]._contractAddress != address(0), "Token not currently supported.");
        return (swapDetails[symbol]._isERC20, swapDetails[symbol]._contractAddress, swapDetails[symbol]._migrationAddress);
    }

    function setDetails(string memory symbol, bool isERC20, address contractAddress, address migrationAddress) public {
        swapDetails.push(Details(isERC20, contractAddress, migrationAddress));
    }

}