// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {PriceConverter} from "contracts/PriceConverter.sol";

contract FundMe{

    using PriceConverter for uint256;

    uint256 internal minInUSD = 5 * 10 ** 18;
    address[] funders;
    mapping (address => uint256) addressToAmount;
    address owner;

    constructor(){
        owner = msg.sender;
    }

    function fund() public payable {
        // 1e18 = 1 eth = 1 * 10 ** 18 wei
        // require(msg.value > 1e18, "at least 1 eth");
        require(msg.value.getConversionRate() > minInUSD, "at least 5 dollars");
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
        require(owner == msg.sender, "Must be owner!");
        _;
    }

}