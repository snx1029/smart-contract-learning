// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {PriceConverter} from "contracts/PriceConverter.sol";
error MustOwner();

contract FundMe{

    using PriceConverter for uint256;

    uint256 internal constant MIN_IN_USD = 5 * 10 ** 18;
    address[] funders;
    mapping (address => uint256) addressToAmount;
    address immutable i_owner;

    constructor(){
        i_owner = msg.sender;
    }

    function fund() public payable {
        // 1e18 = 1 eth = 1 * 10 ** 18 wei
        // require(msg.value > 1e18, "at least 1 eth");
        require(msg.value.getConversionRate() > MIN_IN_USD, "at least 5 dollars");
        funders.push(msg.sender);
        addressToAmount[msg.sender] += msg.value;
    }


    function withdraw() public onlyOwner{
        for(uint256 i = 0; i < funders.length; i++){
            address funder = funders[i];
            addressToAmount[funder] = 0;
        }

        funders = new address[](0);
        (bool success, /* bytes memory data */) = payable (msg.sender).call{value: address(this).balance}("");
        require(success, "Withdraw failed.");
    }
    
    modifier onlyOwner(){
        // require(i_owner == msg.sender, "Must be owner!");
        if(i_owner != msg.sender){
            revert MustOwner();
        }
        _;
    }

    receive() external payable {
        fund();
    }

    fallback() external payable { 
        fund();
    }

}