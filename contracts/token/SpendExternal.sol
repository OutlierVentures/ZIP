pragma solidity ^0.6.0;

import "./Interface.sol";
import "../utils/SafeMath.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/GSN/GSNRecipient.sol";

contract SpendExternal is Context {
    using SafeMath for uint256;

    function increaseExternalAllowance(address contractAddress, address spender, uint256 addedValue) internal {
        Interface externalToken = Interface(contractAddress);
        uint256 spenderCurrentAllowance = externalToken.allowance(_msgSender(), spender);
        externalToken.approve(spender, spenderCurrentAllowance.add(addedValue));
    }

    function decreaseExternalAllowance(address contractAddress, address spender, uint256 subtractedValue) internal {
        Interface externalToken = Interface(contractAddress);
        uint256 spenderCurrentAllowance = externalToken.allowance(_msgSender(), spender);
        externalToken.approve(spender, spenderCurrentAllowance.sub(subtractedValue, "ERC20: decreased allowance below zero"));
    }
}
