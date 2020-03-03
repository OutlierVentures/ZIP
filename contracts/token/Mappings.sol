pragma solidity ^0.5.0;

/**
 * @dev Maps token symbols to contract addresses.
 */
contract Mappings is OnlyOwner{
    mapping(string => address) public contractAddresses;
    mapping(string => address) public migrationAddresses;

    function updateContractAddress(string symbol, address contractAddress) public {
        contractAddresses[symbol] = contractAddress;
    }
}