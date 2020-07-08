const HDWalletProvider = require("@truffle/hdwallet-provider");
const { option } = require("commander");

const getReadOnlyProvider = (options) => {    
    if (!options.rpcNode) {
        throw('rpc node url is not specified');
    }

    return options.rpcNode;
}

const getProvider = (options) => {
    if (!option.rpcNode) {
        throw('rpc node url is not specified');
    }

    if (!options.privateKey) {
        throw('private key is not specified');
    }

    return new HDWalletProvider(options.privateKey, option.rpcNode);
}

module.exports = {
    getReadOnlyProvider,
    getProvider
}