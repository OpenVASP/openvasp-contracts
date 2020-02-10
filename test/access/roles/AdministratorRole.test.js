const { accounts, contract } = require('@openzeppelin/test-environment');
const { expectRevert, constants, expectEvent } = require('@openzeppelin/test-helpers');
const { ZERO_ADDRESS } = constants;

const { expect } = require('chai');

const AdministratorRoleMock = contract.fromArtifact('AdministratorRoleMock');

describe('AdministratorRole', function() {

    const [ authorized, otherAuthorized, other ] = accounts;

    it('emits AdministratorAdded events during initialization', async function () {
        const contract = await AdministratorRoleMock.new();
        const receipt = await contract['initialize'](authorized);

        expectEvent(receipt, `AdministratorAdded`, { account: authorized });
    });

    describe('after initialization', function() {

        beforeEach('check preconditions', async function () {

            this.contract = await AdministratorRoleMock.new();

            await this.contract['initialize'](authorized);
            await this.contract['addAdministrator'](otherAuthorized, { from: authorized });

            expect(await this.contract['isAdministrator'](authorized)).to.equal(true);
            expect(await this.contract['isAdministrator'](otherAuthorized)).to.equal(true);
            expect(await this.contract['isAdministrator'](other)).to.equal(false);
        });

        it('reverts when querying roles for the zero address', async function () {
            await expectRevert(this.contract['isAdministrator'](ZERO_ADDRESS),
                'Roles: account is the zero address'
            );
        });

        describe('access control', function () {
            context('from authorized account', function () {
                const from = authorized;

                it('allows access', async function () {
                    await this.contract['onlyAdministratorMock']({ from });
                });
            });

            context('from unauthorized account', function () {
                const from = other;

                it('reverts', async function () {
                    await expectRevert(this.contract['onlyAdministratorMock']({ from }),
                        'AdministratorRole: caller does not have the Administrator role'
                    );
                });
            });
        });

        describe('add', function () {
            const from = authorized;

            context('from the account account with an assigned role', function () {
                it('adds role to a new account', async function () {
                    await this.contract['addAdministrator'](other, { from });
                    expect(await this.contract['isAdministrator'](other)).to.equal(true);
                });

                it(`emits an AdministratorAdded event`, async function () {
                    const receipt = await this.contract['addAdministrator'](other, { from });
                    expectEvent(receipt, `AdministratorAdded`, { account: other });
                });

                it('reverts when adding role to the already assigned account', async function () {
                    await expectRevert(this.contract['addAdministrator'](authorized, { from }),
                        'Roles: account already has role'
                    );
                });

                it('reverts when adding role to the null account', async function () {
                    await expectRevert(this.contract['addAdministrator'](ZERO_ADDRESS, { from }),
                        'Roles: account is the zero address'
                    );
                });
            });
        });

        describe('remove', function () {
            const from = other;

            it('removes role from an already assigned account', async function () {
                await this.contract['removeAdministratorMock'](authorized, { from });
                expect(await this.contract['isAdministrator'](authorized)).to.equal(false);
                expect(await this.contract['isAdministrator'](otherAuthorized)).to.equal(true);
            });

            it('emits a AdministratorRemoved event', async function () {
                const receipt = await this.contract['removeAdministratorMock'](authorized, { from });
                expectEvent(receipt, 'AdministratorRemoved', { account: authorized });
            });

            it('reverts when removing from an unassigned account', async function () {
                await expectRevert(this.contract['removeAdministratorMock'](other, { from }),
                    'Roles: account does not have role'
                );
            });

            it('reverts when removing role from the zero address', async function () {
                await expectRevert(this.contract['removeAdministratorMock'](ZERO_ADDRESS, { from }),
                    'Roles: account is the zero address'
                );
            });
        });

        describe('renouncing roles', function () {
            it('renounces an assigned role', async function () {
                await this.contract['renounceAdministrator']({ from: authorized });
                expect(await this.contract['isAdministrator'](authorized)).to.equal(false);
            });

            it('emits a AdministratorRemoved event', async function () {
                const receipt = await this.contract['renounceAdministrator']({ from: authorized });
                expectEvent(receipt, 'AdministratorRemoved', { account: authorized });
            });

            it('reverts when renouncing unassigned role', async function () {
                await expectRevert(this.contract['renounceAdministrator']({ from: other }),
                    'Roles: account does not have role'
                );
            });
        });

    });
});