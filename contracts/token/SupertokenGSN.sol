pragma solidity ^0.5.0;

import "./Supertoken";
import "@openzeppelin/contracts-ethereum-package/contracts/GSN/GSNRecipient.sol";

// @dev An extension of Supertoken for GSN.
contract SupertokenGSN is Supertoken, GSNRecipient {

    // GSN: accept relayed call.

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

    // @dev GSN: preprocessing for relayed calls.
    function _preRelayedCall(bytes memory context) internal returns (bytes32) {
    }

    // @dev GSN: postprocessing for relayed calls.
    function _postRelayedCall(bytes memory context, bool, uint256 actualCharge, bytes32) internal {
    }

}