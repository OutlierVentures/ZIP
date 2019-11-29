pragma solidity >=0.4.22 <0.6.0;

contract GasFuture {

    address public buyer;
    address public seller;

    mapping (address => uint) balances;

	event Transfer(address indexed _from, address indexed _to, uint256 _value);

	constructor(address buyer_address, address seller_address) public {
        buyer = buyer_address;
        seller = seller_address;
	}

}