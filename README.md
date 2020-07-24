# OpenVASP Contracts

This repository contains smart contracts for the reference implementation of the OpenVASP standard

**NB!** Node v10 is required

# Build

1. Execute `npm install`.
2. Execute `npx oz compile`.

# Test

1. Execute `npm install`.
2. Execute `npm test`.

# Command Line Interface (CLI)

## Installation

```
npm install -g @openvasp/contracts
```

## Usage

### Deployment

Common options:

`--generate-tx-data-only` - instead of transaction execution, CLI will ouput tx-data only. This tx-data can be used to deploy smart contract/execute operation manually with a suitable wallet software.

`--private-key <private-key>` - sign transaction with a specified private key.

`--rpc-node <rpc-node-url>` - send transaction via specified rpc node url.

#### Deploy VASP Contract Factory

```
openvasp deploy vasp-contract-factory
```

#### Deploy VASP Directory

```
openvasp deploy vasp-directory
```

Options:

`--owner <owner-address>` - address of an owner

`--administrator <administrator-address>` - address of an administrator


#### Deploy VASP Index

```
openvasp deploy vasp-index
```

`--owner <owner-address>` - address of an owner

`--vasp-contract-factory <factory-address>` - address of a VASP Contract Factory. If not specified, VASP Contract Factory will be deployed automatically. Required if used with `--generate-tx-data-only` option.

#### Create VASP Contract

```
openvasp deploy vasp-contract
```

Options:

`--vasp-index <vasp-index-address>` - address of a VASP Index

`--vasp-code <vasp-code>` - string containing a VASP Code          

`--owner <owner-address>` - address of an owner            

`--channels <channels>` - string containing hexadecimal representation of a 4-bytes channels value

`--transport-key <transport-key>` - string containing hexadecimal representation of a transport key

`--message-key <message-key>` - string containing hexadecimal representation of a message key       

`--signing-key <signing-key>` - string containing hexadecimal representation of a signing key

### Fetching Data

Common options:

`--rpc-node <rpc-node-url>` - send transaction via specified rpc node url.

#### Get VASP Code

```
openvasp get vasp-code
```

Options:

`--vasp-index <vasp-index-address>` - address of a VASP Index

`--vasp-contract <vasp-contract-address>` - address of a VASP Contract

#### Get Vasp Contract Address

```
openvasp get vasp-contract
```

Options:

`--vasp-index <vasp-index-address>` - address of a VASP Index

`--vasp-code <vasp-code>` - string containing a VASP Code          

#### Get VASP Info

```
openvasp get vasp-info
```

Options:

`--vasp-contract <vasp-contract-address>` - address of a VASP Contract