# OpenVASP Contracts

This repository contains smart contracts for the reference implementation of the OpenVASP standard

# Build

**NB!** Node v10 is required

1. Execute `npm install`.
2. Execute `npm run build`.

# Test

**NB!** Node v10 is required

1. Execute `npm install`.
2. Execute `npm test`.

# Deploy

**NB!** Node v10 is required

## For local development

(It is expected, that `ganache-cli` or similar development Ethereum server is up and running)

1. Execute `npm install`.
2. Execute `npm run deploy-index -- --network development` or `npm run deploy-directory -- --network development`.

## To the Ethereum network

1. Execute `npm install`
2. Create `.env` file. Specify (see `.env.template`):
  - `PRIVATE_KEY` private key to sign deployment transaction;
  - `NODE_URL` json rpc node url for Ethereum network. 
3. Execute `npm run deploy-index -- --network ethereum` or `npm run deploy-directory -- --network ethereum`.
4. Do not forget to remove `.env` file.