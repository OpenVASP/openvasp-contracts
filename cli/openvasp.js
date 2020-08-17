#!/usr/bin/env node

const program = require('commander');

program
    .version('1.0.0')
    .description('OpenVASP Contracts CLI');

program
    .command('create', 'create OpenVASP ecosystem smart contract')
    .command('deploy', 'deploy OpenVASP ecosystem smart contract')
    .command('get', 'get infromation from OpenVASP ecosystem')
    .command('insert', 'save infromation in OpenVASP ecosystem');

program
    .parse(process.argv);