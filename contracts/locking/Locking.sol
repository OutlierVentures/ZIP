pragma solidity ^0.5.0;

contract Locking {

    /**
     * @dev Emitted when native token collateral is locked in this contract.
     * Contains the `amount` plus the `totalLocked`, i.e. the amount which should exist as a wrapped token on Ethereum.
     *
     * Note that both `amount` and `totalLocked` may be zero.
     */
    event Lock(uint256 amount, uint256 totalLocked);
    
}