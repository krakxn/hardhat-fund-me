const { networkConfig, developmentChains } = require("../helper-hardhat-config")
const { network, deployments, getNamedAccounts } = require("hardhat")
const { verify } = require("../utils/verify")
// Instead of const { getNamedAccounts, deployments } = hre
module.exports = async ({ getNamedAccounts, deployments }) => {
    const { deploy, log } = deployments
    const { deployer } = await getNamedAccounts()
    const chainId = network.config.chainId
    let ethUsdPriceFeedAddress
    // local network
    if (chainId == 31337) {
        const ethUsdAggregator = await deployments.get("MockV3Aggregator")
        ethUsdPriceFeedAddress = ethUsdAggregator.address
    } else {
        ethUsdPriceFeedAddress = networkConfig[chainId]["ethUsdPriceFeed"]
    }
    // when going for a local network such as hardhat or localhost we should use a mock
    const args = [ethUsdPriceFeedAddress]
    const fundMe = await deploy("FundMe", {
        from: deployer,
        args: args, // put price feed addy
        log: true,
        waitConfirmations: network.config.blockConfirmations || 1, // if no blockConfirmations given in hardhat.config
    })
    if (
        !developmentChains.includes(network.name) &&
        process.env.ETHERSCAN_API_KEY
    ) {
        await verify(fundMe.address, args)
    }
    log("----------------------------------------------------")
}

module.exports.tags = ["all", "fundme"]
