// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract FundMe{

    uint256 internal minInUSD = 5 * 10 ** 18;

    function fund() public payable {
        // 1e18 = 1 eth = 1 * 10 ** 18 wei
        // require(msg.value > 1e18, "at least 1 eth");
        require(getConversionRate(msg.value) > minInUSD, "at least 5 dollars");

    }


    function withdraw() public {

    }

    // Price of ETH in terms of USD
    function getPrice() public view returns(uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (, int256 answer, , , ) = priceFeed.latestRoundData();
        // ETH/USD rate in 18 digits
        // return uint256(answer * 1e10);
        return uint256(answer);
    }

    function getConversionRate(uint256 ethAmount) public view returns(uint256){
        uint256 ethPrice = getPrice();
        uint256 ethInUSD = (ethPrice * ethAmount) / 1e18;
        return ethInUSD;
    }


}