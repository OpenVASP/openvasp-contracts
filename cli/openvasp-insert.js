#!/usr/bin/env node

const program = require('commander');
const { sendTransaction } = require('./blockchain.js');
const { registerGenerateTxDataOnlyOption, registerProviderOptions, addressOption, fileOption, vaspIdOption } = require('./options.js');
const { getProvider } = require('./provider.js');

const vaspDirectoryArtifact = require('../build/contracts/VASPDirectory.json');

registerGenerateTxDataOnlyOption(program);
registerProviderOptions(program);

program
    .command('directory-credentials')
    .requiredOption('--vasp-directory <vasp-directory-address>', '', addressOption)
    .requiredOption('--vasp-id <vasp-id>', '', vaspIdOption)
    .requiredOption('--vasp-credentials <vasp-credentials-file-path>', '', fileOption)
    .action(async (command) => {
        try {

            const provider = getProvider(program);

            if (provider !== null) {
                console.log('Inserting VASP credentials...')
            }

            const sendTransactionResult = await sendTransaction(
                provider,
                vaspDirectoryArtifact,
                command.vaspDirectory,
                'insertCredentials',
                command.vaspId,
                command.vaspCredentials
            );

            if (provider !== null) {
                processSuccess('VASP Credentials inserted');
            } else {
                outputSendTransactionGuide(sendTransactionResult, command.vaspDirectory);
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