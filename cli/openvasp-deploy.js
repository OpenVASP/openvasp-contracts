#!/usr/bin/env node

const program = require('commander');
const Web3  = require('web3');
const { deployContract } = require('./blockchain.js');
const { registerProviderOptions, addressOption } = require('./options.js');
const { getProvider } = require('./provider.js');

const vaspContractFactoryArtifact = require('../build/contracts/VASPContractFactory.json');
const vaspDirectoryArtifact = require('../build/contracts/VASPDirectory.json');
const vaspIndexArtifact = require('../build/contracts/VASPIndex.json');

registerProviderOptions(program);

program
    .command('vasp-contract-factory')
    .action(async () => {
        try {
            const provider = getProvider(program);

            console.log('Deploying VASP Contract Factory...')
            const vaspContractFactoryAddress = await deployContract(provider, vaspContractFactoryArtifact);
            console.log('- done');
            console.log(vaspContractFactoryAddress);
            process.exit();
        } catch(error) {
            console.log('- failed');
            console.log(error);
            process.exit(-1);
        }
    });

program
    .command('vasp-directory')
    .requiredOption('--owner <owner-address>', '', addressOption)
    .requiredOption('--administrator <administrator-address>', '', addressOption)
    .action(async (command) => {
        try {
            const provider = getProvider(program);

            console.log('Deploying VASP Directory...')
            const vaspDirectoryAddress = await deployContract(provider, vaspDirectoryArtifact, command.owner, command.administrator);
            console.log('- done');
            console.log(vaspDirectoryAddress);
            process.exit();
        } catch(error) {
            console.log('- failed');
            console.error(error);
            process.exit(-1);
        }
    });

program
    .command('vasp-index')
    .requiredOption('--owner <owner-address>', '', addressOption)
    .option('--vasp-contract-factory <factory-address>', '', addressOption)
    .action(async (command) => {
        try {
            const provider = getProvider(program);

            if (!command.vaspContractFactory) {
                console.log('Deploying VASP Contract Factory (prerequisite)...')
                command.vaspContractFactory = await deployContract(provider, vaspContractFactoryArtifact);
                console.log('- done');    
            }

            console.log('Deploying VASP Index...')
            const vaspIndexAddress = await deployContract(provider, vaspIndexArtifact, command.owner, command.vaspContractFactory);
            console.log('- done');
            console.log(vaspIndexAddress);
            process.exit();

        } catch(error) {
            console.log('- failed');
            console.error(error);
            process.exit(-1);
        }
    });

program
    .parse(process.argv);