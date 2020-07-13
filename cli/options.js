const Web3  = require('web3');
const web3 = new Web3();

const addressOption = (value, previous) => {
    if(!web3.utils.isAddress(value)) {
        throw(`${value} is not an address`);
    }

    return value;
}

const channelsOption = (value, previous) => {
    if (!/^0x[0-9a-fA-F]{8}$/.test(value)) {
        throw(`${value} is not a valid channels value`);
    }

    return value;
}

const hexStringOption  = (value, previous) => {
    if (!/^0x[0-9a-fA-F]*$/.test(value)) {
        throw(`${value} is not a valid hex string`);
    }

    return value;
}

const modeOption = (value, previous) => {
    if (!Object.values(modes).includes(value)) {
        console.error(`Unxpected mode value: ${value}`);
        process.exit(-1);
    }

    return value;
}

const privateKeyOption  = (value, previous) => {
    if (!/^[0-9a-fA-F]{64}$/.test(value)) {
        throw(`${value} is not a valid private key string`);
    }

    return value;
}

const vaspCodeOption = (value, previous) => {
    if (!/^[0-9a-fA-F]{8}$/.test(value)) {
        throw(`${value} is not a VASP code`);
    }

    return `0x${value}`;
}

const registerGenerateTxDataOnlyOption = (program) => {
    program.option(
        '--generate-tx-data-only',
        ''
    ); 
}

const registerProviderOptions = (program) => {
    program.option(
        '--private-key <private-key>',
        '',
        privateKeyOption);

    program.option(
        '--rpc-node <rpc-node-url>',
        '');
}

module.exports = {
    registerGenerateTxDataOnlyOption,
    registerProviderOptions,
    addressOption,
    channelsOption,
    hexStringOption,
    modeOption,
    vaspCodeOption
}