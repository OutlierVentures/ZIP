pragma solidity ^0.5.0;

import "../token/ZIPI.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/GSN/GSNRecipient.sol";

contract DemoDapp is GSNRecipient {

    /**
     * @dev Example dapp function: spend a base token from the basket.
     */
    function spendBaseToken() external returns (bool) {
        ZIPI zip = ZIPI(address(0)); // Replace 0 address with ZIP address
        zip.transfer(address(this), 100); // Send 100 ZIP to dapp
        // Send 100 ZIP worth of FET to this dapp's Etch contract
        zip.redeem("FET", 100, "0xTHISDAPPCONTRACTFETCHADDRESS");
        return true;
    }

    /**
     * @dev GSN: accept relayed call.
     */
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

    /**
     * @dev GSN: preprocessing for relayed calls.
     */
    function _preRelayedCall(bytes memory context) internal returns (bytes32) {
    }

    /**
     * @dev GSN: postprocessing for relayed calls.
     */
    function _postRelayedCall(bytes memory context, bool, uint256 actualCharge, bytes32) internal {
    }

}