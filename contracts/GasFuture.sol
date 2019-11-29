pragma solidity >=0.4.22 <0.6.0;

contract GasFuture {

    uint escrow_balance;
    address public buyer;
    address public seller;
    uint private price;
    uint private start;
    uint private length_days;

    mapping (address => uint) balances;

	event Transfer(address indexed _from, address indexed _to, uint256 _value);

	constructor(address buyer_address, address seller_address, uint agreed_price, uint contract_length_days) public {
        start = block.timestamp;
        buyer = buyer_address;
        seller = seller_address;
        price = agreed_price;
        length_days = contract_length_days;
	}

    function deposit() public payable {
        if (msg.sender == buyer) {
            escrow_balance += msg.value;
        }
    }

}