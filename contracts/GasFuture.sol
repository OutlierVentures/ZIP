pragma solidity >=0.4.22 <0.6.0;

contract GasFuture {

    mapping (address => uint) balances;

	event Transfer(address indexed _from, address indexed _to, uint256 _value);

	constructor() public {
	}

}