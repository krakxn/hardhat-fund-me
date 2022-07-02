# (Hardhat) FundMe

This project demonstrates an advanced Hardhat use case, integrating other tools commonly used alongside Hardhat in the ecosystem.

The project comes with basic tests, scripts and mocks, and can be used for crowdfunding (funding and withdrawing). The contract is also verified via Etherscan.

*The following can be changed or more can be added as per choice via hardhat.config.js*

> Current networks: Rinkeby, Goerli
> Current currency: USD
> Current token: ETH

Try running the following to get the complete list of commands available:

```shell
npx hardhat
```

or,

```shell
yarn hardhat
```

# Etherscan verification

To try out Etherscan verification, you first need to deploy a contract to an Ethereum network that's supported by Etherscan, such as Rinkeby and Goerli.

In this project, copy the .env.example file to a file named .env, and then edit it to fill in the details. Enter your Etherscan API key, your Ropsten node URL (eg from Alchemy), and the private key of the account which will send the deployment transaction. With a valid .env file in place, first deploy your contract:

```shell
hardhat run scripts/deploy.js --network rinkeby
```
