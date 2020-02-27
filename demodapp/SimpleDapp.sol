pragma solidity ^0.5.0;

import "../contracts/token/Interface.sol";
import "../contracts/utils/Context.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/GSN/GSNRecipient.sol";

contract SimpleDapp is GSNRecipient {

    /**
     * @dev Example dapp function: spend a base token from the basket.
     */
    function withdrawBasetoken() external returns (bool) {
        private st = Interface("0x514910771af9ca656af840dff83e8264ecf986ca") // Specify Supertoken address
        st.transfer(address(this), 100) // Send 100 fuel to dapp
        st.redeem("0x85117168851e99b6fa06bc8a58e035dc50587541", 100) // Grab 100 FUEL worth of FET
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