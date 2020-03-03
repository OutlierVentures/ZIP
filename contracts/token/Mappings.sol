pragma solidity ^0.5.0;

/**
 * @dev Maps token symbols to contract and migartion addreses addresses.
 */
contract Mappings is OnlyOwner {
    mapping(string => address) public contractAddresses;
    mapping(string => address) public migrationAddresses;

    function getContractAddress(string symbol) public {
        require(contractAddresses[symbol].active, "Token not currently supported.");
        return contractAddresses[symbol];
    }

    function setContractAddress(string symbol, address contractAddress) public {
        contractAddresses[symbol] = contractAddress;
    }

    function getMigrationAddress(string symbol) public {
        require(migrationAddresses[symbol].active, "Token not currently supported for migration.");
        return migrationAddresses[symbol];
    }

    function setMigrationAddress(string symbol, address migrationAddress) public {
        migrationAddresses[symbol] = migrationAddress;
    }

}