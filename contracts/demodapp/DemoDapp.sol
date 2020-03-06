pragma solidity ^0.5.0;

import "../token/Interface.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/GSN/GSNRecipient.sol";

// DEV NOTE: OpenZeppelin GSN Contracts already define Context, so no need to inherit the local Context contract.

contract DemoDapp { //is GSNRecipient {

    /**
     * @dev Example dapp function: spend a base token from the basket.
     */
    function spendBaseToken() external returns (bool) {
        Inteface fuel = Interface("0xFUELADDRESS"); // Specify FUEL address
        fuel.transfer(address(this), 100); // Send 100 fuel to dapp
        // Send 100 FUEL worth of FET to this dapp's Etch contract
        fuel.redeem("FET", 100, "0xTHISDAPPCONTRACTFETCHADDRESS");
        return true;
    }

    /* GSN below, see dev note above before enabling

    function acceptRelayedCall(
        address relay,
        address from,
        bytes calldata encodedFunction,
        uint256 transactionFee,
        uint256 gasPrice,
        uint256 gasLimit,
        uint256 nonce,
        bytes calldata approvalData,
        uint256 maxPossibleCharge
    ) external view returns (uint256, bytes memory) {
        return _approveRelayedCall();
    }

    function _preRelayedCall(bytes memory context) internal returns (bytes32) {
    }

    function _postRelayedCall(bytes memory context, bool, uint256 actualCharge, bytes32) internal {
    }

    */

}