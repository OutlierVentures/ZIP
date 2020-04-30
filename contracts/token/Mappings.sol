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
        bool isERC20;
        address contractAddress;
        address migrationAddress;
    }
    mapping(string => Details) public swapDetails;

    function getDetails(string memory symbol) public view returns (bool, address, address) {
        require(swapDetails[symbol].contractAddress != address(0), "Token not currently supported.");
        return (swapDetails[symbol].isERC20, swapDetails[symbol].contractAddress, swapDetails[symbol].migrationAddress);
    }

}