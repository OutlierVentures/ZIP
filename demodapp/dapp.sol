pragma solidity ^0.5.0;

import "../contracts/token/Interface.sol";
import "../contracts/utils/Context.sol";

contract SimpleDapp {

    function withdrawBasetoken() external returns (bool) {
        private st = Interface("0x514910771af9ca656af840dff83e8264ecf986ca") // Specify Supertoken address
        st.transfer(address(this), 100) // Send 100 fuel to dapp
        st.withdraw("0x85117168851e99b6fa06bc8a58e035dc50587541", 100) // Withdraw 100 FUEL worth of FET

    }
}