const { networkConfig, developmentChains } = require("../helper-hardhat-config")
const { network, deployments, getNamedAccounts } = require("hardhat")
const { verify } = require("../utils/verify")
// Instead of const { getNamedAccounts, deployments } = hre
module.exports = async ({ getNamedAccounts, deployments }) => {
    const { deploy, log } = deployments
    const { deployer } = await getNamedAccounts()
    const chainId = network.config.chainId
    let ethUsdPriceFeedAddress
    // Local network
    if (chainId == 31337) {
        const ethUsdAggregator = await deployments.get("MockV3Aggregator")
        ethUsdPriceFeedAddress = ethUsdAggregator.address
    } else {
        ethUsdPriceFeedAddress = networkConfig[chainId]["ethUsdPriceFeed"]
    }
    // When going for a local network such as hardhat or localhost we should use a mock
    const args = [ethUsdPriceFeedAddress]
    const fundMe = await deploy("FundMe", {
        from: deployer,
        args: args, // Pricefeed address
        log: true,
        waitConfirmations: network.config.blockConfirmations || 1, // If no blockConfirmations given in hardhat.config
    })
    if ( // If not a local network, we verify the contract
        !developmentChains.includes(network.name) &&
        process.env.ETHERSCAN_API_KEY
    ) {
        await verify(fundMe.address, args)
    }
    log("----------------------------------------------------")
}

module.exports.tags = ["all", "fundme"]
