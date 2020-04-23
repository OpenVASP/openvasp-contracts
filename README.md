# OpenVASP Contracts

This repository contains smart contracts for the reference implementation of the OpenVASP standard

## How to create a new VASP smart contract

You can use smart contract [Vasp Facade (0xb838ef6121b8093f425fdc336d59e1142c2e289)](https://ropsten.etherscan.io/address/0xb838ef6121b8093f425fdc336d59e1142c2e289) to create new instance of CASP smart contract. 
After call method `build` you can see in transaction event `VaspCreated` where in first parameter you can see newVaspAddress.
The address that broadcast transaction with `build` is automatically set as the owner and administrator.

1. open page https://ropsten.etherscan.io/address/0xb838ef6121b8093f425fdc336d59e1142c2e289c#writeContract
2. call metod `build` and fill 5 params
3. check event `VaspCreated` in transaction


# Build and deploy manually

## Running tests

Execute `npm run test` command.

## Build and deployment by truffle

1. Execute `npm install -g truffle` to install [Truffle](https://www.trufflesuite.com/docs/truffle/getting-started/installation)
2. Create `.env` file. Specify (see `.env.template`):
2.1. `PRIVATE_KEY` private key for broadcast deployment transaction. 
2.2. `ROPSTEN_NODE_URL` json rpc node url for Ropsten network.
2.3. `ETHEREUM_NODE_URL` json rpc node url for Ethereum network.
2.3. `ETHERSCAN_API_KEY` API key from Etherscan account in a case to verify smart contract on Etherscan
3. Execite `npm install` to install dependencies
4. Run local ganache node to test smart contract: `ganache-cli`. 
5. Execite `truffle compile` to compile smart contracts
6. Execite `truffle test` to run tests
7. Execite `truffle migrate` to deploy smart contract into local ganache node
8. Execite `truffle migrate --network ropsten` to deploy smart contract into Ropsten network
9. Execite `truffle migrate --network ethereum` to deploy smart contract into Ethereum network
9. Verify smart contract on Etherscan
9.1. Execite `truffle run verify VASP --network ropsten`
9.1. Execite `truffle run verify VaspFactory --network ropsten`

## Deployment by openzepelin

1. Create `.env` file. Specify `ROPSTEN_PRIVATE_KEY` and `ROPSTEN_NODE_URL` with correct values in it (see `.env.template`).
2. Execute `npx oz create VASP --network ropsten`
3. Agree to initialize the instance after creating it
4. Choose `initialize(owner: address, initialAdministrators: address[])` option
5. Provide an owner's address
6. Provide administrators' addresses
7. Specify administrator's private key in the `.env` file
8. Execute `npx oz send-tx <VASP instance address> --method setPostalAddress --args "address line", "post code", "town", "country" --network ropsten` to set postal address.
9. Execute `npx oz send-tx <VASP instance address> --method setName --args "VASP name" --network ropsten` to set VASP name.
10. Execute `npx oz send-tx <VASP instance address> --method setEmail --args "VASP e-mail" --network ropsten` to set VASP e-mail.
11. Execute `npx oz send-tx <VASP instance address> --method setWebsite --args "VASP website url" --network ropsten` to set VASP website url.
12. Preserve `./openzeppelin/ropsten.json` file for future use.

## A `______gap` variable

In some smart contracts you can find a `______gap` variable.

Since OpenZeppelin contracts are used by inheritance, user-defined variables will be placed by the compiler after OpenZeppelin’s ones. If, in a newer version, new variables are added by the library, the storage layouts would be incompatible, and an upgrade would not be possible. 

The gap is a workaround to that issue: by leaving a 50-slot gap, we’re able to increase the contract’s storage by that amount (provided we also remove the same slots from the gap) with no clashing issues.