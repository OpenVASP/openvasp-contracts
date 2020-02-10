# OpenVASP Contracts

This repository contains smart contracts for the reference implementation of the OpenVASP standard

## Running tests

Execute `npm run test` command.

## Deployment

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