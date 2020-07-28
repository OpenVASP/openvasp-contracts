#!/usr/bin/env node

const program = require('commander');
const { sendTransaction } = require('./blockchain.js');
const { registerGenerateTxDataOnlyOption, registerProviderOptions, addressOption, channelsOption, compressedPublicKeyOption, vaspCodeOption } = require('./options.js');
const { getProvider } = require('./provider.js');

const vaspIndexArtifact = require('../build/contracts/VASPIndex.json');

registerGenerateTxDataOnlyOption(program);
registerProviderOptions(program);

program
    .command('vasp-contract')
    .requiredOption('--vasp-index <vasp-index-address>', '', addressOption)
    .requiredOption('--vasp-code <vasp-code>', '', vaspCodeOption)
    .requiredOption('--owner <owner-address>', '', addressOption)
    .requiredOption('--channels <channels>', '', channelsOption)
    .requiredOption('--transport-key <transport-key>', '', compressedPublicKeyOption)
    .requiredOption('--message-key <message-key>', '', compressedPublicKeyOption)
    .requiredOption('--signing-key <signing-key>', '', compressedPublicKeyOption)
    .action(async (command) => {
        try {

            const provider = getProvider(program);

            if (provider !== null) {
                console.log('Creating VASP Contract...')
            }

            const sendTransactionResult = await sendTransaction(
                provider,
                vaspIndexArtifact,
                command.vaspIndex,
                'createVASPContract',
                command.vaspCode,
                command.owner,
                command.channels,
                command.transportKey,
                command.messageKey,
                command.signingKey
            );

            if (provider !== null) {
                processSuccess(sendTransactionResult.events['VASPContractCreated'].returnValues['vaspAddress']);
            } else {
                outputSendTransactionGuide(sendTransactionResult, command.vaspIndex);
            }

        } catch(error) {
            processError(error);
        }
    });

program
    .parse(process.argv);

function processError(error) {
    console.log(error);
    process.exit(-1);
}

function processSuccess(result) {
    console.log('- done');
    console.log(result);
    process.exit();
}

function outputSendTransactionGuide(txData, contractAddress) {
    console.log('Send transaction with a following data:');
    console.log();
    console.log(txData);
    console.log();
    console.log('to the following address:')
    console.log();
    console.log(contractAddress);
    process.exit();
}