/// Conforms to the Solidity style guide, the sorting method used is at the end of program
/// In addition, follows Chainlink style guide (for storage and immutable variables)

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "./PriceConverter.sol";

error FundMe__NotOwner();

/**@title A sample Funding Contract
 * @notice This contract is for creating a sample funding contract
 * @dev This implements price feeds as our library
 */
contract FundMe {
    using PriceConverter for uint256; /// Attributes defined in PriceConverter can now be used for uint256 variables
    uint256 public constant MINIMUM_USD = 50 * 10**18; /// 50 * 10^18 -- 1 ETH = 10^18 Wei
    address private immutable i_owner;
    address[] private s_funders;
    mapping(address => uint256) private s_addressToAmountFunded; /// address as key maps to uint256
    AggregatorV3Interface private s_priceFeed;

    modifier onlyOwner() {
        if (msg.sender != i_owner) revert FundMe__NotOwner();
        /// Alternative:
        /// require(msg.sender == i_owner);
        _;
    }

    constructor(address priceFeed) {
        s_priceFeed = AggregatorV3Interface(priceFeed);
        i_owner = msg.sender;
    }

    /// @notice Funds our contract based on the ETH/USD price
    function fund() public payable {
        require(
            msg.value.getConversionRate(s_priceFeed) >= MINIMUM_USD,
            "You need to spend more ETH!"
        );
        /// Alternative:
        /// require(PriceConverter.getConversionRate(msg.value) >= MINIMUM_USD, "You need to spend more ETH!");
        s_addressToAmountFunded[msg.sender] += msg.value;
        s_funders.push(msg.sender);
    }

    function withdraw() public payable onlyOwner {
        for (
            uint256 funderIndex = 0;
            funderIndex < s_funders.length;
            funderIndex++
        ) {
            address funder = s_funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }
        s_funders = new address[](0);
        /// Transfer:
        /// payable(msg.sender).transfer(address(this).balance);
        /// Call:
        (bool success, ) = i_owner.call{value: address(this).balance}("");
        require(success);
    }
    
    /// Gas optimized version
    function cheaperWithdraw() public payable onlyOwner {
        address[] memory funders = s_funders;
        /// Mappings can't be in memory, sorry!
        for (
            uint256 funderIndex = 0;
            funderIndex < funders.length;
            funderIndex++
        ) {
            address funder = funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }
        s_funders = new address[](0);
        /// Transfer:
        /// payable(msg.sender).transfer(address(this).balance);
        /// Call:
        (bool success, ) = i_owner.call{value: address(this).balance}("");
        require(success);
    }

    /** @notice Gets the amount that an address has funded
     *  @param fundingAddress the address of the funder
     *  @return the amount funded
     */
    function getAddressToAmountFunded(address fundingAddress)
        public
        view
        returns (uint256)
    {
        return s_addressToAmountFunded[fundingAddress];
    }
    
    /// Getter functions (for private):
    function getVersion() public view returns (uint256) {
        return s_priceFeed.version();
    }

    function getFunder(uint256 index) public view returns (address) {
        return s_funders[index];
    }

    function getOwner() public view returns (address) {
        return i_owner;
    }

    function getPriceFeed() public view returns (AggregatorV3Interface) {
        return s_priceFeed;
    }
}

/// The sorting pattern:
/// 1. Pragma
/// 2. Imports
/// 3. Interfaces, Libraries, Contracts
/// Type Declarations
/// State variables
/// Modifiers
