pragma solidity ^0.5.0;

import "../token/Interface.sol";
import "../token/FUEL.sol";
import "../token/Mappings.sol";
import "../utils/ConvertLib.sol";

contract GasFuture is ConvertLib, Mappings {

    address payable public buyer;
    address payable public seller;
    string public baseTokenSymbol;
    address public fuelAddress;
    uint256 private price;
    uint256 private start_date;
    uint256 private length_days;
    uint256 private numberOfTokens;
    uint256 private escrow_balance;
    bool private buyerAccepts;
    bool private sellerAccepts;

	constructor(address payable buyer_address, address payable seller_address, uint256 agreed_price_in_eth, uint256 contract_length_days) public {
        start_date = block.timestamp;
        buyer = buyer_address;
        seller = seller_address;
        price = agreed_price_in_eth;
        length_days = contract_length_days;
        numberOfTokens = convert(price, address(0), address(this));
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

    /**
     * Start the contract within a day of initializing, assuming the full price is paid down, otherwise return funds.
     * Successful start transfers the base tokens to this contract's address. The contract deposits these in exchange
     * for FUEL, which grants an allowance from the basket with FUEL.redeem().
     */
    function start() public payable {
        if (!(block.timestamp >= start_date + 1 days) && escrow_balance >= price) {
            Interface(getContractAddress(baseTokenSymbol)).transferFrom(seller, fuelAddress, numberOfTokens);
            FUEL(fuelAddress).deposit(baseTokenSymbol, numberOfTokens); // WARN account for FUEL fees
        } else {
            selfdestruct(buyer);
        }
    }

    /**
     * Settle the contract after its expiry. Successful settlement transfers this contract's FUEL to the buyer
     * and the escrow balance to the seller. The buyer can use FUEL to pay for gas with FUEL.redeem().
     */
    function settle() public payable {
        require(block.timestamp > start_date + length_days * 1 days, "Contract not yet expired");
        Interface(fuelAddress).transfer(buyer, numberOfTokens);
        seller.transfer(price);
        escrow_balance -= price;
    }

}