// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol"; /// Price datafeed

/// Library for reuse
library PriceConverter {
    function getPrice(AggregatorV3Interface priceFeed)
        internal
        view
        returns (uint256) {
        /// Rinkeby ETH / USD Address is used
        /// For a list of addresses: https://docs.chain.link/docs/ethereum-addresses/
        (, int256 answer, , , ) = priceFeed.latestRoundData();
        
        /// To get ETH/USD rate in 18 digits (Answer is 8 zeros)
        return uint256(answer * 10000000000); /// 8 zeros * 10 zeros = 18 zeros
    }

    function getConversionRate(
        uint256 ethAmount,
        AggregatorV3Interface priceFeed
    ) internal view returns (uint256) {
        uint256 ethPrice = getPrice(priceFeed);
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1000000000000000000; /// 18 digits
        
        /// The actual ETH/USD conversion rate, after adjusting the extra 0s.
        return ethAmountInUsd;
    }
}
