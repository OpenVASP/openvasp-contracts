#!/usr/bin/env node

const program = require('commander');
const { callContract } = require('./blockchain.js');
const { registerProviderOptions, addressOption, vaspCodeOption } = require('./options.js');
const { getReadOnlyProvider } = require('./provider.js');

const vaspContractArtifact = require('../build/contracts/VASPContract.json');
const vaspIndexArtifact = require('../build/contracts/VASPIndex.json');
const vaspCodeRegex = /0x([0-9A-Fa-f]{8})/;

registerProviderOptions(program);

program
    .command('vasp-code')
    .requiredOption('--vasp-index <vasp-index-address>', '', addressOption)
    .requiredOption('--vasp-contract <vasp-contract-address>', '', addressOption)
    .action(async (command) => {
        const provider = getReadOnlyProvider(program);
        const callResult = await callContract(provider, vaspIndexArtifact, command.vaspIndex, 'getVASPCodeByAddress', command.vaspContract);
        console.log(callResult.match(vaspCodeRegex)[1]);
    });

program
    .command('vasp-contract')
    .requiredOption('--vasp-index <vasp-index-address>', '', addressOption)
    .requiredOption('--vasp-code <vasp-code>', '', vaspCodeOption)
    .action(async (command) => {
        const provider = getReadOnlyProvider(program);
        const callResult = await callContract(provider, vaspIndexArtifact, command.vaspIndex, 'getVASPAddressByCode', command.vaspCode);
        console.log(callResult);
    });

program
    .command('vasp-info')
    .requiredOption('--vasp-contract <vasp-contract-address>', '', addressOption)
    .action(async (command) => {
        const provider = getReadOnlyProvider(program);
        console.log({
            vaspCode:    (await callContract(provider, vaspContractArtifact, command.vaspContract, 'vaspCode')).match(vaspCodeRegex)[1],
            channels:     await callContract(provider, vaspContractArtifact, command.vaspContract, 'channels'),
            transportKey: await callContract(provider, vaspContractArtifact, command.vaspContract, 'transportKey'),
            messageKey:   await callContract(provider, vaspContractArtifact, command.vaspContract, 'messageKey'),
            signingKey:   await callContract(provider, vaspContractArtifact, command.vaspContract, 'signingKey')
        });
    });

program
    .parse(process.argv);