pragma solidity ^0.6.0;

contract Locking {

    /**
     * @dev Locks `amount` of the chain-native token in this contract..
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Lock} event.
     */
    function lock(uint256 amount) public payable returns (bool) {
        require(msg.value == amount, "Sending a different amount to that specified.");
        emit Lock(amount, address(this).balance);
        return true;
    }
    
    /**
     * @dev Emitted when native token collateral is locked in this contract.
     * Contains the `amount` plus the `totalLocked`, i.e. the amount which should exist as a wrapped token on Ethereum.
     *
     * Note that both `amount` and `totalLocked` may be zero.
     */
    event Lock(uint256 amount, uint256 totalLocked);

}