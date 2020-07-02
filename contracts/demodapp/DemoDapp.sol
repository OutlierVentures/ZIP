pragma solidity ^0.6.0;

import "../token/ZIPI.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/GSN/GSNRecipientSignature.sol";

contract DemoDapp is GSNRecipientSignatureUpgradeSafe {

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
        bytes memory encodedFunction,
        uint256 transactionFee,
        uint256 gasPrice,
        uint256 gasLimit,
        uint256 nonce,
        bytes memory approvalData,
        uint256 maxPossibleCharge
    ) public override view returns (uint256, bytes memory) {
        return _approveRelayedCall();
    }

    /**
     * @dev GSN: preprocessing for relayed calls.
     */
    function _preRelayedCall(bytes memory context) internal override returns (bytes32) {
    }

    /**
     * @dev GSN: postprocessing for relayed calls.
     */
    function _postRelayedCall(bytes memory context, bool, uint256 actualCharge, bytes32) internal override {
    }

}
