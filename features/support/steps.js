const { After, Before, Given, When, Then } = require("cucumber");
const { expect } = require("chai");
const { expectRevert, constants, expectEvent } = require('@openzeppelin/test-helpers');

const { accounts, contract } = require('@openzeppelin/test-environment');

const VASPIndex = contract.fromArtifact('VASPIndex');

const [ vaspIndexDeployerAccount, firstOwnerAccount, secondOwnerAccount, anybodyElseAccount ] = accounts;

Before(async function() {
    this.contracts = {
        vaspIndex: await VASPIndex.new()
    }

    this.state.vaspCodeThatIsUsed    = "0x1000000000000000";
    this.state.vaspCodeThatIsNotUsed = "0x2000000000000000";

    await this.contracts.vaspIndex.createVASPContract(firstOwnerAccount, this.state.vaspCodeThatIsUsed, { from: vaspIndexDeployerAccount });
});

Given(/^I\'m (.*)$/, function (role) {
    switch(role) {
        case 'a VASP Index deployer':
            this.inputs.from = vaspIndexDeployerAccount;
            break;
        case 'not a VASP Index deployer':
            this.inputs.from = anybodyElseAccount;
            break;
        default:
            throw 'I\'m <unexpected>';
    }
});

Given(/^owner address is (.*)$/, function (ownerAddress) {
    switch(ownerAddress) {
        case 'non-zero address':
            this.inputs.ownerAddress = firstOwnerAccount;
            break;
        case 'the zero address':
            this.inputs.ownerAddress = constants.ZERO_ADDRESS;
            break;
        default:
            throw 'owner address is <unexpected>';
    }
});

Given(/^VASP code is (.*)$/, function (vaspCode) {
    switch(vaspCode) {
        case 'not used yet':
            this.inputs.vaspCode = this.state.vaspCodeThatIsNotUsed;
            break;
        case 'already in use':
            this.inputs.vaspCode = this.state.vaspCodeThatIsUsed;
            break;
        case 'empty':
            this.inputs.vaspCode = this.constants.EMPTY_VASP_CODE;
            break;
        default:
            throw 'VASP code is <unexpected>';
    }
});

When(/^creating a VASP contract$/, async function() {

    this.tx = {
        result: null,
        error:  null
    };

    try {
        this.tx.result = await this.contracts.vaspIndex.createVASPContract(this.inputs.ownerAddress, this.inputs.vaspCode, { from: this.inputs.from });
    } catch (error) {
        this.tx.error = error.message;
    }

});

Then(/^transaction execution result is (.*)$/, function (result) {
    switch (result) {
        case 'success':
            expect(this.tx.result).to.be.not.null;
            expect(this.tx.result.receipt.status).to.be.true;
            break;
        case 'failure':
            expect(this.tx.result).to.be.null;
            expect(this.tx.error).to.be.not.null;
            break;
        default:
            throw 'transaction execution result is <unexpected>';
    }
});

Then(/^transaction failure reason is (.*)$/, function (reason) {

    switch(reason) {
        case 'empty':
            expect(this.tx.error).to.be.null;
            break;
        default:
            this.tx.error = this.tx.error.replace(
                /Returned error: VM Exception while processing transaction: (revert )?/,
                '',
            );

            this.tx.error = this.tx.error.replace(
                / -- Reason given: (.*)./,
                '',
            );

            expect(this.tx.error).to.equal(reason, 'Wrong kind of exception received');
            break;
    }

});