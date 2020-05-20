pragma solidity ^0.5.0;

import "./DraizenCoin.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/distribution/RefundablePostDeliveryCrowdsale.sol";

// @TODO: Inherit the crowdsale contracts
contract DraizenCoinSale is Crowdsale, MintedCrowdsale, CappedCrowdsale, TimedCrowdsale, RefundablePostDeliveryCrowdsale{

    constructor(
        // @TODO: Fill in the constructor parameters!
        uint rate, // rate in TKNbits
        address payable wallet, // sale beneficiary
        DraizenCoin token, // the PupperCoin Token itself that the PupperCoin TokenSale will work with
        uint goal, // fundraising goal for PupperCoin sale
        uint cap, // total cap 
        uint openingTime, //  opening time in unix epoch seconds
        uint closingTime // closingTime time in unix epoch seconds
    )
        // @TODO: Pass the constructor parameters to the crowdsale contracts.
        MintedCrowdsale()
        RefundableCrowdsale(goal)
        Crowdsale (rate, wallet, token)
        TimedCrowdsale (openingTime, closingTime)
        PostDeliveryCrowdsale()
        CappedCrowdsale (goal)
        public
    {
        // constructor can stay empty
    }
}

contract DraizenCoinSaleDeployer {

    address public draizen_sale_address;  // contract address
    address public token_address;

    constructor(
        // @TODO: Fill in the constructor parameters!
        string memory name,
        string memory symbol,
        address payable wallet // this address will receive all Ether raised by the sale
        
    )
        public
    {
        // @TODO: create the PupperCoin and keep its address handy
        DraizenCoin token = new DraizenCoin(name, symbol, 0);
        token_address = address(token);

        // @TODO: create the PupperCoinSale and tell it about the token, set the goal, and set the open and close times to now and now + 24 weeks.
        uint goal = 300;
        uint cap = 300;
        
        
        DraizenCoinSale draizen_sale = new DraizenCoinSale(1, wallet, token, goal, cap, now, now + 24 weeks);
        draizen_sale_address = address(draizen_sale);
        
        // openingTime(now);
        // closingTime(now + 24 weeks);

        // make the PupperCoinSale contract a minter, then have the PupperCoinSaleDeployer renounce its minter role
        token.addMinter(draizen_sale_address);
        token.renounceMinter();
    }
}