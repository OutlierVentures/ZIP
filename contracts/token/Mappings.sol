pragma solidity ^0.5.0;

import "../utils/OnlyOwner.sol"

/**
 * @dev Maps token symbols to contract and migartion addreses addresses.
 */
contract Mappings is OnlyOwner {
    mapping(string => address) public contractAddresses;
    mapping(string => address) public migrationAddresses;

    function getContractAddress(string memory symbol) public {
        require(contractAddresses[symbol].active, "Token not currently supported.");
        return contractAddresses[symbol];
    }

    function setContractAddress(string memory symbol, address contractAddress) public {
        contractAddresses[symbol] = contractAddress;
    }

    function getMigrationAddress(string memory symbol) public {
        require(migrationAddresses[symbol].active, "Token not currently supported for migration.");
        return migrationAddresses[symbol];
    }

    function setMigrationAddress(string memory symbol, address migrationAddress) public {
        migrationAddresses[symbol] = migrationAddress;
    }

}