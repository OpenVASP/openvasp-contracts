#!/usr/bin/env node

const program = require('commander');
const { sendTransaction } = require('./blockchain.js');
const { registerProviderOptions, addressOption, channelsOption, hexStringOption, vaspCodeOption } = require('./options.js');
const { getProvider } = require('./provider.js');

const vaspIndexArtifact = require('../build/contracts/VASPIndex.json');

registerProviderOptions(program);

program
    .command('vasp-contract')
    .requiredOption('--vasp-index <vasp-index-address>', '', addressOption)
    .requiredOption('--vasp-code <vasp-code>', '', vaspCodeOption)
    .requiredOption('--owner <owner-address>', '', addressOption)
    .requiredOption('--channels <channels>', '', channelsOption)
    .requiredOption('--transport-key <transport-key>', '', hexStringOption)
    .requiredOption('--message-key <message-key>', '', hexStringOption)
    .requiredOption('--signing-key <signing-key>', '', hexStringOption)
    .action(async (command) => {
        try {
            const provider = getProvider(program);

            console.log('Creating VASP Contract...')
            const contractCreationRersult = await sendTransaction(
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

            console.log('- done');
            console.log(contractCreationRersult.events['VASPContractCreated'].returnValues['vaspAddress']);
            process.exit();
        } catch(error) {
            console.log('- failed');
            console.log(error);
            process.exit(-1);
        }
    });

program
    .parse(process.argv);