pragma solidity >=0.4.22 <0.6.0;

contract GasFuture {

    address public buyer;
    address public seller;
    uint private price;
    uint private start;
    uint private length_days;
    uint escrow_balance;
    bool buyerAccepts;
    bool sellerAccepts;

    mapping (address => uint) balances;

	event Transfer(address indexed _from, address indexed _to, uint256 _value);

	constructor(address buyer_address, address seller_address, uint agreed_price, uint contract_length_days) public {
        start = block.timestamp;
        buyer = buyer_address;
        seller = seller_address;
        price = agreed_price;
        length_days = contract_length_days;
	}

    // The buyer and seller accept the terms by calling this function
    function accept() public {
        if (msg.sender == buyer){
            buyerAccepts = true;
        } else if (msg.sender == seller){
            sellerAccepts = true;
        }
    }

    function deposit() public payable {
        if (msg.sender == buyer && buyerAccepts && sellerAccepts) {
            escrow_balance += msg.value;
        }
    }

}