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
    ethereum: {
      provider: function () {
        return new HDWalletProvider(process.env.PRIVATE_KEY, process.env.NODE_URL);
      },
      network_id: '*'
    }
  }
};
