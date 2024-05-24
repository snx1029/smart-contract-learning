// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library PriceConverter{
    // Price of ETH in terms of USD
    function getPrice() internal view returns(uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (, int256 answer, , , ) = priceFeed.latestRoundData();
        // ETH/USD rate in 18 digits
        return uint256(answer * 1e10);
    }

    function getConversionRate(uint256 ethAmount) internal view returns(uint256){
        uint256 ethPrice = getPrice();
        uint256 ethInUSD = (ethPrice * ethAmount) / 1e18;
        return ethInUSD;
    }
}