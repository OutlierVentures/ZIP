pragma solidity ^0.5.0;

contract SwapInterface {

    function transferToNativeTargetAddress(uint256 amount, string calldata nativeAddress) external;
    
}