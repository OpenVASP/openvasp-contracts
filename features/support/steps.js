const fs = require('fs');
const { After, Before, Given, When, Then } = require("cucumber");
const { expect } = require("chai");
const { expectRevert, constants, expectEvent } = require('@openzeppelin/test-helpers');
const { accounts, contract } = require('@openzeppelin/test-environment');

const VASPContractFactory = contract.fromArtifact('VASPContractFactory');
const VASPDirectory = contract.fromArtifact('VASPDirectory');
const VASPIndex = contract.fromArtifact('VASPIndex');


const [ deployer, owner, newOwnerCandidate, administrator, regularUser ] = accounts;

const EMPTY_BYTES32 = "0x0000000000000000000000000000000000000000000000000000000000000000";

// Common

Given(/^I\'m (.*)$/, function(role) {
    switch(role) {
        case 'an administrator':
            this.role = administrator;
            break;
        case 'a regular user':
            this.role = regularUser;
            break;
        default:
            throw `${role} is unexpected role`;
    }
})

Given(/^VASP code is "(.*)"$/, function(vaspCode) {
    this.inputs.vaspCode = `0x${vaspCode}`;
})

Given(/^VASP identifier is "(.*)"$/, function(vaspId) {
    this.inputs.vaspId = `0x${vaspId}`;
})

Then(/^transaction should succeed$/, function() {
    expect(this.result.receipt).to.be.not.null;
    expect(this.result.receipt.status).to.be.true;
})

Then(/^transaction should fail with a following error: "(.*)"$/, function(expectedError) {
    let actualError = this.result.message.replace(
        /Returned error: VM Exception while processing transaction: (revert )?/,
        '',
    );

    actualError = actualError.replace(
        / -- Reason given: (.*)./,
        '',
    );

    expect(actualError).to.equal(expectedError, 'Wrong kind of exception received');
})

Then(/^"(.*)" event should be logged$/, function(event) {
    expectEvent(this.result.receipt, event);

    this.currentEvent = event
})

// VASPIndex

Before({tags: "@vasp-index"}, async function () {
    this.contracts.vaspContractFactory = await VASPContractFactory.new(
        { from: deployer }
    );

    this.contracts.vaspIndex = await VASPIndex.new(
        owner,
        this.contracts.vaspContractFactory.address,
        { from: deployer }
    );
});

Then(/^logged VASP code should be "(.*)"$/, function(vaspCode) {
    expectEvent(
        this.result.receipt,
        this.currentEvent,
        { vaspCode: `0x${vaspCode}00000000000000000000000000000000000000000000000000000000` }
    );
})

// VASPDirectory

Before({tags: "@vasp-directory"}, async function () {
    this.contracts.vaspDirectory = await VASPDirectory.new(
        owner,
        administrator,
        { from: deployer }
    );
});

Given(/^VASP with identifier "(.*)" registered in the directory with credentials from "(.*)"$/, async function(vaspId, vaspCredentials) {
    await this.contracts.vaspDirectory.insertCredentials(
        `0x${vaspId}`,
        fs.readFileSync(`./features/support/${vaspCredentials}`, 'utf8'),
        { from: administrator }
    );
})

Given(/^VASP credentials are specified in "(.*)"$/, function(vaspCredentials) {
    this.inputs.vaspCredentials = fs.readFileSync(`./features/support/${vaspCredentials}`, 'utf8');
})

When(/^inserting VASP credentials$/, async function() {
    try {
        this.result = await this.contracts.vaspDirectory.insertCredentials(
            this.inputs.vaspId,
            this.inputs.vaspCredentials,
            { from: this.role }
        );
    } catch(error) {
        this.result = error;
    }
})

When(/^revoking VASP credentials$/, async function() {
    try {
        this.result = await this.contracts.vaspDirectory.revokeCredentials(
            this.inputs.vaspId,
            { from: this.role }
        );
    } catch(error) {
        this.result = error;
    }
})

When(/^requesting VASP credentials reference$/, async function() {
    this.result = await this.contracts.vaspDirectory.getCredentialsRef(
        this.inputs.vaspId,
        { from: this.role }
    );
})

Then(/^credentials should be inserted$/, async function() {
    const callResult = await this.contracts.vaspDirectory.getCredentialsRef(
        this.inputs.vaspId,
        { from: regularUser }
    );

    // TODO: Validate ref and hash values
    expect(callResult.credentialsRef).to.be.not.empty;
    expect(callResult.credentialsHash).to.not.equal(EMPTY_BYTES32);
})

Then(/^credentials should be revoked$/, async function() {
    const callResult = await this.contracts.vaspDirectory.getCredentialsRef(
        this.inputs.vaspId,
        { from: regularUser }
    );

    expect(callResult.credentialsRef).to.be.empty;
    expect(callResult.credentialsHash).to.equal(EMPTY_BYTES32);
})

Then(/^logged VASP identifier should be "(.*)"$/, function(vaspId) {
    expectEvent(
        this.result.receipt,
        this.currentEvent,
        { vaspId: `0x${vaspId}0000000000000000000000000000000000000000000000000000` }
    );
})

Then(/^logged credentials reference should be "(.*)"$/, function(credentialsRef) {
    expectEvent(
        this.result.receipt,
        this.currentEvent,
        { credentialsRef: credentialsRef }
    );
})

Then(/^logged credentials hash should be "(.*)"$/, function(credentialsHash) {
    expectEvent(
        this.result.receipt,
        this.currentEvent,
        { credentialsHash: credentialsHash }
    );
})

Then(/^logged credentials should be same as in "(.*)"$/, function(credentials) {
    expectEvent(
        this.result.receipt,
        this.currentEvent,
        { credentials: fs.readFileSync(`./features/support/${credentials}`, 'utf8') }
    );
})

Then(/^returned VASP credentials reference should be "(.*)"$/, function(credentialsRef) {
    expect(this.result.credentialsRef).to.equal(credentialsRef);
})

Then(/^returned VASP credentials hash should be "(.*)"$/, function(credentialsHash) {
    expect(this.result.credentialsHash).to.equal(credentialsHash);
})

Then(/^returned VASP credentials reference should be empty$/, function() {
    expect(this.result.credentialsRef).to.be.empty;
})

Then(/^returned VASP credentials hash should be empty$/, function() {
    expect(this.result.credentialsHash).to.equal(EMPTY_BYTES32);
})