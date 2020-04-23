const { accounts, contract } = require('@openzeppelin/test-environment');
const { expect } = require('chai');
const { expectRevert, constants, expectEvent } = require('@openzeppelin/test-helpers');

const VASPMock = contract.fromArtifact('VASP');

describe('VASP', function() {

    const [ owner, administrator, other ] = accounts;

    describe('deployment', function() {

        it('does not revert', function() {
            expect(async function() { await VASPMock.new() }).to.not.throw();
        });

    });

    describe('after deployment', function() {

        beforeEach(async function () {
            this.contract = await VASPMock.new();
        });

        describe('initially', function() {

            it('channels list is empty', async function() {
                expect((await this.contract.channelsCount())).to.be.bignumber.equal('0');
            });

            it('code is valid', async function() {
                const lastAddressBytes = this.contract.address.substring(this.contract.address.length - 8);
                expect(await this.contract.code()).to.be.equal(`0x${lastAddressBytes.toLowerCase()}`);
            });

            it('email is empty', async function() {
                expect((await this.contract.email())).to.be.empty;
            });

            it('handshake key is empty', async function() {
                expect((await this.contract.handshakeKey())).to.be.empty;
            });

            it('identity claims list is empty', async function() {
                expect((await this.contract.identityClaimsCount())).to.be.bignumber.equal('0');
            });

            it('name is empty', async function() {
                expect((await this.contract.name())).to.be.empty;
            });

            describe('postal address', function() {

                let postalAddress;

                beforeEach(async function() {
                    postalAddress = await this.contract.postalAddress();
                });

                it('street name is empty', async function() {
                    expect(postalAddress.streetName).to.be.empty;
                });

                it('building number is empty', async function() {
                    expect(postalAddress.buildingNumber).to.be.empty;
                });

                it('address line is empty', async function() {
                    expect(postalAddress.addressLine).to.be.empty;
                });

                it('post code is empty', async function() {
                    expect(postalAddress.postCode).to.be.empty;
                });

                it('town is empty', async function() {
                    expect(postalAddress.town).to.be.empty;
                });

                it('country is empty', async function() {
                    expect(postalAddress.country).to.be.empty;
                });

            });

            it('signing key is empty', async function() {
                expect((await this.contract.signingKey())).to.be.empty;
            });

            it('trusted peers list is empty', async function() {
                expect((await this.contract.trustedPeersCount())).to.be.bignumber.equal('0');
            });

            it('website is empty', async function() {
                expect((await this.contract.handshakeKey())).to.be.empty;
            });

        });

        describe('during initialization', function() {

            it('owner is assigned', async function() {
                await this.contract.initialize(owner);

                expect((await this.contract.owner())).to.equal(owner);
            });

        });

        describe('after initialization', function() {

            beforeEach(async function() {
                await this.contract.initialize(owner);
                await this.contract.addAdministrator(administrator, { from: owner });
            });

            describe('adding channel', function() {

                describe('from administrator account', function() {

                    it('adds channel to the list', async function() {
                        await this.contract.addChannel(0, { from: administrator });

                        expect((await this.contract.channelsCount())).to.be.bignumber.equal('1');
                    });

                    describe('when channel has already been added', function() {

                        beforeEach(async function() {
                            await this.contract.addChannel(0, { from: administrator });
                        });

                        it('reverts', async function() {

                            await expectRevert(this.contract.addChannel(0, { from: administrator }),
                                'Channels: set already contains the specified channel'
                            );

                        });

                    })

                });

                describe('from other account', function() {

                    it('reverts', async function() {
                        await expectRevert(this.contract['addChannel'](0, { from: other }),
                            'AdministratorRole: caller does not have the Administrator role'
                        );
                    });

                });

            });

            describe('adding trusted peer', function() {

                describe('from administrator account', function() {

                    it('adds trusted peer to the list', async function() {
                        await this.contract.addTrustedPeer(other, { from: administrator });

                        expect((await this.contract.trustedPeersCount())).to.be.bignumber.equal('1');
                    });

                    describe('when trusted peer has already been added', function() {

                        beforeEach(async function() {
                            await this.contract.addTrustedPeer(other, { from: administrator });
                        });

                        it('reverts', async function() {

                            await expectRevert(this.contract.addTrustedPeer(other, { from: administrator }),
                                'Addresses: set already contains address'
                            );

                        });

                    })

                });

                describe('from other account', function() {

                    it('reverts', async function() {
                        await expectRevert(this.contract.addTrustedPeer(other, { from: other }),
                            'AdministratorRole: caller does not have the Administrator role'
                        );
                    });

                });

            });

            describe('adding identity claim', function() {

                describe('from administrator account', function() {

                    it('adds identity claim to the list', async function() {
                        await this.contract.addIdentityClaim(other, { from: administrator });

                        expect((await this.contract.identityClaimsCount())).to.be.bignumber.equal('1');
                    });

                    describe('when identity claim has already been added', function() {

                        beforeEach(async function() {
                            await this.contract.addIdentityClaim(other, { from: administrator });
                        });

                        it('reverts', async function() {

                            await expectRevert(this.contract.addIdentityClaim(other, { from: administrator }),
                                'Addresses: set already contains address'
                            );

                        });

                    })

                });

                describe('from other account', function() {

                    it('reverts', async function() {
                        await expectRevert(this.contract.addIdentityClaim(other, { from: other }),
                            'AdministratorRole: caller does not have the Administrator role'
                        );
                    });

                });

            });

            describe('setting e-mail', function() {

                describe('from administrator account', function() {

                    it('changes e-mail value', async function() {
                        await this.contract.setEmail("test@openvasp.org", { from: administrator });

                        expect((await this.contract.email())).to.equal("test@openvasp.org");
                    });

                    describe('when provided value is the same as a current value', function() {

                        beforeEach(async function() {
                            await this.contract.setEmail("test@openvasp.org", { from: administrator });
                        });

                        it('reverts', async function() {

                            await expectRevert(this.contract.setEmail("test@openvasp.org", { from: administrator }),
                                'VASP: specified e-mail has already been set'
                            );

                        });

                    });

                    describe('when provided value is empty', function() {

                        it('reverts', async function() {

                            await expectRevert(this.contract.setEmail("", { from: administrator }),
                                'VASP: newEmail is an empty string'
                            );

                        });

                    });

                });

                describe('from other account', function() {

                    it('reverts', async function() {

                        await expectRevert(this.contract.setEmail("test@openvasp.org", { from: other }),
                            'AdministratorRole: caller does not have the Administrator role'
                        );

                    });

                });

            });

            describe('setting handshake key', function() {

                const handshakeKey = "0x043ca2e15917499a0c7de20f03a17b82a0aab1450dcaa0d704c5d969090bc10a2b1e3e60ef1d17b5201b2c35b124058cb1e034305574dfccdffda9e895a813672b";

                describe('from administrator account', function() {

                    it('changes handshake key', async function() {
                        await this.contract.setHandshakeKey(handshakeKey, { from: administrator } );

                        expect((await this.contract.handshakeKey())).to.equal(handshakeKey);
                    });

                    describe('when provided value is the same as a current value', function() {

                        beforeEach(async function() {
                            await this.contract.setHandshakeKey(handshakeKey, { from: administrator } );
                        });

                        it('reverts', async function() {

                            await expectRevert(this.contract.setHandshakeKey(handshakeKey, { from: administrator }),
                                'VASP: specified handshake key has already been set'
                            );

                        });

                    });

                    describe('when provided value is empty', function() {

                        it('reverts', async function() {

                            await expectRevert(this.contract.setHandshakeKey("", { from: administrator }),
                                'VASP: newHandshakeKey is an empty string'
                            );

                        });

                    });

                });

                describe('from other account', function() {

                    it('reverts', async function() {

                        await expectRevert(this.contract.setHandshakeKey(handshakeKey, { from: other }),
                            'AdministratorRole: caller does not have the Administrator role'
                        );

                    });

                });

            });

            describe('setting name', function() {

                describe('from administrator account', function() {

                    it('changes name value', async function() {
                        await this.contract.setName("Lykke Business", { from: administrator });

                        expect((await this.contract.name())).to.equal("Lykke Business");
                    });

                    describe('when provided value is the same as a current value', function() {

                        beforeEach(async function() {
                            await this.contract.setName("Lykke Business", { from: administrator });
                        });

                        it('reverts', async function() {

                            await expectRevert(this.contract.setName("Lykke Business", { from: administrator }),
                                'VASP: specified name has already been set'
                            );

                        });

                    });

                    describe('when provided value is empty', function() {

                        it('reverts', async function() {

                            await expectRevert(this.contract.setName("", { from: administrator }),
                                'VASP: newName is an empty string'
                            );

                        });

                    });

                });

                describe('from other account', function() {

                    it('reverts', async function() {

                        await expectRevert(this.contract.setName("Lykke Business", { from: other }),
                            'AdministratorRole: caller does not have the Administrator role'
                        );

                    });

                });

            });

            describe('setting postal address', function() {

                describe('from administrator account', function() {

                    describe('when provided address is the same as a current one', function() {

                        it('reverts', async function() {

                            await this.contract.setPostalAddress("street name", "42", "12300", "Zug", "CH", { from: administrator });

                            await expectRevert(this.contract.setPostalAddress("street name", "42", "12300", "Zug", "CH", { from: administrator }),
                                'VASP: specified postal address has already been set'
                            );

                        });
                    });

                    describe('when street name is empty', function() {

                        it('reverts', async function() {

                            await expectRevert(this.contract.setPostalAddress("", "42", "12300", "Zug", "CH", { from: administrator }),
                                'VASP: street name is not specified'
                            );

                        });

                    });

                    describe('when building number is empty', function() {

                        it('reverts', async function() {

                            await expectRevert(this.contract.setPostalAddress("street name", "", "12300", "Zug", "CH", { from: administrator }),
                                'VASP: building number is not specified'
                            );

                        });

                    });

                    describe('when post code is empty', function() {

                        it('reverts', async function() {

                            await expectRevert(this.contract.setPostalAddress("street name", "42", "", "Zug", "CH", { from: administrator }),
                                'VASP: post code is not specified'
                            );

                        });

                    });

                    describe('when town is empty', function() {

                        it('reverts', async function() {

                            await expectRevert(this.contract.setPostalAddress("street name", "42", "12300", "", "CH", { from: administrator }),
                                'VASP: town is not specified'
                            );

                        });

                    });

                    describe('when country is empty', function() {

                        it('reverts', async function() {

                            await expectRevert(this.contract.setPostalAddress("street name", "42", "12300", "Zug", "", { from: administrator }),
                                'VASP: country is not specified'
                            );

                        });

                    });

                });

                describe('from other account', function() {

                    it('reverts', async function() {

                        await expectRevert(this.contract.setPostalAddress("street name", "42", "12300", "Zug", "CH", { from: other }),
                            'AdministratorRole: caller does not have the Administrator role'
                        );

                    });

                });

            });

            describe('setting signing key', function() {

                const signingKey = "0x043ca2e15917499a0c7de20f03a17b82a0aab1450dcaa0d704c5d969090bc10a2b1e3e60ef1d17b5201b2c35b124058cb1e034305574dfccdffda9e895a813672b";

                describe('from administrator account', function() {

                    it('changes handshake key', async function() {
                        await this.contract.setSigningKey(signingKey, { from: administrator } );

                        expect((await this.contract.signingKey())).to.equal(signingKey);
                    });

                    describe('when provided value is the same as a current value', function() {

                        beforeEach(async function() {
                            await this.contract.setSigningKey(signingKey, { from: administrator } );
                        });

                        it('reverts', async function() {

                            await expectRevert(this.contract.setSigningKey(signingKey, { from: administrator }),
                                'VASP: specified signing key has already been set'
                            );

                        });

                    });

                    describe('when provided value is empty', function() {

                        it('reverts', async function() {

                            await expectRevert(this.contract.setSigningKey("", { from: administrator }),
                                'VASP: newSigningKey is an empty string'
                            );

                        });

                    });

                });

                describe('from other account', function() {

                    it('reverts', async function() {

                        await expectRevert(this.contract.setSigningKey(signingKey, { from: other }),
                            'AdministratorRole: caller does not have the Administrator role'
                        );

                    });

                });

            });

            describe('setting website', function() {

                describe('from administrator account', function() {

                    it('changes website value', async function() {
                        await this.contract.setWebsite("openvasp.org", { from: administrator });

                        expect((await this.contract.website())).to.equal("openvasp.org");
                    });

                    describe('when provided value is the same as a current value', function() {

                        beforeEach(async function() {
                            await this.contract.setWebsite("openvasp.org", { from: administrator });
                        });

                        it('reverts', async function() {

                            await expectRevert(this.contract.setWebsite("openvasp.org", { from: administrator }),
                                'VASP: specified website has already been set'
                            );

                        });

                    });

                    describe('when provided value is empty', function() {

                        it('reverts', async function() {

                            await expectRevert(this.contract.setWebsite("", { from: administrator }),
                                'VASP: newWebsite is an empty string'
                            );

                        });

                    });

                });

                describe('from other account', function() {

                    it('reverts', async function() {

                        await expectRevert(this.contract.setWebsite("openvasp.org", { from: other }),
                            'AdministratorRole: caller does not have the Administrator role'
                        );

                    });

                });

            });

        });
    });

});