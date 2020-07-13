const Web3 = require('web3');

const callContract = async (provider, artifact, address, methodName, ...methodArgs) => {
    const web3 = new Web3(provider);
    const contract = new web3.eth.Contract(artifact.abi, address);

    return await contract
        .methods[methodName](...methodArgs)
        .call();
}

const deployContract = async (provider, artifact, ...constructorArgs) => {
    const web3 = new Web3(provider);
    const contract = new web3.eth.Contract(artifact.abi);
    const transaction = contract.deploy({ data: artifact.bytecode, arguments: constructorArgs });

    if (provider !== null) {
        const contractInstance = await transaction.send({ from: provider.addresses[0] });
        return contractInstance.options.address;
    } else {
        return transaction.encodeABI();
    }
}

const sendTransaction = async (provider, artifact, address, method, ...methodArgs) => {
    const web3 = new Web3(provider);
    const contract = new web3.eth.Contract(artifact.abi, address);
    const transaction = contract.methods[method](...methodArgs);

    if (provider !== null) {
        const executionResult = await transaction.send({ from: provider.addresses[0] });
        return executionResult;
    } else {
        return transaction.encodeABI();
    }
}

module.exports = {
    callContract,
    deployContract,
    sendTransaction
}