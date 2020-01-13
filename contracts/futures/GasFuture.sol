pragma solidity ^0.5.0;

contract GasFuture {

    address payable public buyer;
    address payable public seller;
    uint private price;
    uint private start_date;
    uint private length_days;
    uint escrow_balance;
    bool buyerAccepts;
    bool sellerAccepts;

    mapping (address => uint) balances;

	event Transfer(address indexed _from, address indexed _to, uint256 _value);

	constructor(address payable buyer_address, address payable seller_address, uint agreed_price, uint contract_length_days) public {
        start_date = block.timestamp;
        buyer = buyer_address;
        seller = seller_address;
        price = agreed_price;
        length_days = contract_length_days;
	}

    // The buyer and seller accept the terms by calling this function.
    function accept() public {
        if (msg.sender == buyer){
            buyerAccepts = true;
        } else if (msg.sender == seller) {
            sellerAccepts = true;
        }
    }

    function cancel() public {
        if (msg.sender == buyer) {
            buyerAccepts = false;
        } else if (msg.sender == seller) {
            sellerAccepts = false;
        }
        // If both buyer and seller cancel, money is returned to buyer.
        if (!buyerAccepts && !sellerAccepts) {
            // For any potential fees implemented later, this must be checked.
            selfdestruct(buyer);
        }
    }

    function deposit() public payable {
        if (msg.sender == buyer && buyerAccepts && sellerAccepts) {
            escrow_balance += msg.value;
        }
    }

    // Start the contract within a day of initializing, assuming the full price is paid down, otherwise return funds.
    function start() public payable {
        if (!(block.timestamp >= start_date + 1 days) && escrow_balance >= price) {
            seller.transfer(price);
        } else {
            selfdestruct(buyer);
        }
    }

    function settle() public payable {
        if (block.timestamp > start_date + length_days * 1 days) {
            seller.transfer(price);
            escrow_balance -= price;
        }
    }

    // TODO Function to redeem RightToGas for a portion of the future, where the seller buys the equivalent.
    // Seller must be required to purhcase a 'normal' speed transaction quantity of gas.

}