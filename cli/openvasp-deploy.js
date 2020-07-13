#!/usr/bin/env node

const program = require('commander');
const { deployContract } = require('./blockchain.js');
const { registerGenerateTxDataOnlyOption, registerProviderOptions, addressOption } = require('./options.js');
const { getProvider } = require('./provider.js');

const vaspContractFactoryArtifact = require('../build/contracts/VASPContractFactory.json');
const vaspDirectoryArtifact = require('../build/contracts/VASPDirectory.json');
const vaspIndexArtifact = require('../build/contracts/VASPIndex.json');

registerGenerateTxDataOnlyOption(program);
registerProviderOptions(program);

program
    .command('vasp-contract-factory')
    .action(async () => {
        try {
            const provider = getProvider(program);

            if (provider !== null) {
                console.log('Deploying VASP Contract Factory...');
            }

            const deployContractResult = await deployContract(provider, vaspContractFactoryArtifact);

            if (provider !== null) {
                processSuccess(deployContractResult);
            } else {
                outputDeployContractGuide(deployContractResult);
            }

        } catch(error) {
            processError(error);
        }
    });

program
    .command('vasp-directory')
    .requiredOption('--owner <owner-address>', '', addressOption)
    .requiredOption('--administrator <administrator-address>', '', addressOption)
    .action(async (command) => {
        try {
            const provider = getProvider(program);

            if (provider !== null) {
                console.log('Deploying VASP Directory...');
            }

            const deployContractResult = await deployContract(provider, vaspDirectoryArtifact, command.owner, command.administrator);

            if (provider !== null) {
                processSuccess(deployContractResult);
            } else {
                outputDeployContractGuide(deployContractResult);
            }
            
        } catch(error) {
            processError(error);
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
                if (provider !== null) {
                    console.log('Deploying VASP Contract Factory (prerequisite)...')
                    command.vaspContractFactory = await deployContract(provider, vaspContractFactoryArtifact);
                    console.log('- done');    
                    console.log('Deploying VASP Index...')
                } else {
                    throw('error: required option \'--vasp-contract-factory <factory-address>\' not specified');
                }
            }

            const deployContractResult = await deployContract(provider, vaspIndexArtifact, command.owner, command.vaspContractFactory);

            if (provider !== null) {
                processSuccess(deployContractResult);
            } else {
                outputDeployContractGuide(deployContractResult);
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
    
function outputDeployContractGuide(txData) {
    console.log('Send contract deployment transaction with a following data:');
    console.log();
    console.log(txData);
    process.exit();
}