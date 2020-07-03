pragma solidity ^0.6.0;

abstract contract SwapInterface {

    function transferToNativeTargetAddress(uint256 amount, string calldata nativeAddress) external virtual;
    
}