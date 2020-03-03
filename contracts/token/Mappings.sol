pragma solidity ^0.5.0;

/**
 * @dev Maps token symbols to contract addresses
 */
contract Mappings {
    mapping(string => address) public contractAddresses;
    mapping(string => address) public migrationAddresses;
}