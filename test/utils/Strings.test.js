const { contract } = require('@openzeppelin/test-environment');
const { expect } = require('chai');

const StringsMock = contract.fromArtifact('StringsImplementation');

describe('Strings', function() {

    beforeEach(async function() {
        this.contract = await StringsMock.new();
    });

    describe('checking equality', function() {

        it('returns true if strings are equal', async function() {
            expect(await this.contract.equals('open-vasp', 'open-vasp')).to.equal(true);
        });

        it('returns false if strings are not equal', async function() {
            expect(await this.contract.equals('open-vasp', 'other string')).to.equal(false);
        });

    });

    describe("checking if string is empty", function() {

        it('returns true if strings is empty', async function() {
            expect(await this.contract.isEmpty('')).to.equal(true);
        });

        it('returns false if strings is not empty', async function() {
            expect(await this.contract.isEmpty('open-vasp')).to.equal(false);
        });

    });

});