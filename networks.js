require('dotenv').config();

const HDWalletProvider = require("@truffle/hdwallet-provider");

module.exports = {
  networks: {
    development: {
      protocol: 'http',
      host: 'localhost',
      port: 8545,
      gas: 5000000,
      gasPrice: 5e9,
      networkId: '*',
    },
    ropsten: {
      provider: function() {
        return new HDWalletProvider(process.env.ROPSTEN_PRIVATE_KEY, process.env.ROPSTEN_NODE_URL);
      },
      network_id: '3'
    }
  }
};
