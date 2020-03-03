pragma solidity ^0.5.0;

/**
 * @dev Maps token symbols to contract addresses.
 */
contract Mappings is OnlyOwner {
    mapping(string => address) public contractAddresses;
    mapping(string => address) public migrationAddresses;

    contractAddresses["FET"] = address("0x1d287cc25dad7ccaf76a26bc660c5f7c8e2a05bd")

    function updateContractAddress(string symbol, address contractAddress) public {
        contractAddresses[symbol] = contractAddress;
    }

    function updateMigrationAddress(string symbol, address migrationAddress) public {
        migrationAddresses[symbol] = migrationAddress;
    }
    

}