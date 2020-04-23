require('dotenv').config();

const HDWalletProvider = require("@truffle/hdwallet-provider");

module.exports = {
  networks: {
    development: {
      protocol: 'http',
      host: 'localhost',
      port: 8545,
      network_id: '*',
    },
    ropsten: {
      provider: function() {
        return new HDWalletProvider(process.env.PRIVATE_KEY, process.env.ROPSTEN_NODE_URL);
      },
      network_id: '3'
    },
    ethereum: {
      provider: function() {
        return new HDWalletProvider(process.env.PRIVATE_KEY, process.env.ETHEREUM_NODE_URL);
      },
      network_id: '1'
    }
  },
  plugins: [
    'truffle-plugin-verify'
  ],

  api_keys: {
    etherscan: process.env.ETHERSCAN_API_KEY
  }
};
