pragma solidity ^0.5.0;

import "../token/Interface.sol";
import "../token/Supertoken.sol";
import "../utils/ConvertLib.sol";

contract GasFuture {

    address payable public buyer;
    address payable public seller;
    address public basetokenAddress;
    address public supertokenAddress;
    uint private price;
    uint private start_date;
    uint private length_days;
    uint private numberOfTokens;
    uint escrow_balance;
    bool buyerAccepts;
    bool sellerAccepts;

    mapping (address => uint) balances;

	event Transfer(address indexed _from, address indexed _to, uint256 _value);

	constructor(address payable buyer_address, address payable seller_address, uint agreed_price_in_eth, uint contract_length_days) public {
        start_date = block.timestamp;
        buyer = buyer_address;
        seller = seller_address;
        price = agreed_price_in_eth;
        length_days = contract_length_days;
        numberOfTokens = convert(price, symbol, "ETH");
	}

    // The buyer and seller accept the terms by calling this function.
    function accept() public {
        if (msg.sender == buyer) {
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
        require(msg.sender == buyer, "Caller is not the buyer of this contract");
        require(buyerAccepts, "Buyer has not yet accepted terms");
        require(sellerAccepts, "Seller has not yet accepted terms");
        escrow_balance += msg.value;
    }

    // Start the contract within a day of initializing, assuming the full price is paid down, otherwise return funds.
    function start() public payable {
        if (!(block.timestamp >= start_date + 1 days) && escrow_balance >= price) {
            Interface(basetokenAddress).transferFrom(seller, supertokenAddress, numberOfTokens);
            Supertoken(supertokenAddress).deposit(basetokenAddress, numberOfTokens); // WARN account for Supertoken fees
        } else {
            selfdestruct(buyer);
        }
    }

    function settle() public payable {
        require(block.timestamp > start_date + length_days * 1 days, "Contract not yet expired");
        Interface(supertokenAddress).transfer(buyer, numberOfTokens);
        seller.transfer(price);
        escrow_balance -= price;
    }

}