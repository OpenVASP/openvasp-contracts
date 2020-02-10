pragma solidity ^0.5.0;

import "@openzeppelin/contracts-ethereum-package/contracts/GSN/Context.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/ownership/Ownable.sol";
import "@openzeppelin/upgrades/contracts/Initializable.sol";
import "./access/roles/AdministratorRole.sol";
import "./utils/Addresses.sol";
import "./utils/Channels.sol";
import "./utils/Strings.sol";
import "./IVASP.sol";

contract VASP is Initializable, Context, Ownable, AdministratorRole, IVASP {
    using Addresses for Addresses.AddressSet;
    using Addresses for address;
    using Channels for Channels.ChannelSet;
    using Strings for string;

    Channels.ChannelSet private _channels;
    string private _email;
    string private _handshakeKey;
    Addresses.AddressSet private _identityClaims;
    string private _name;
    string private _postalAddressStreetName;
    string private _postalAddressBuildingNumber;
    string private _postalAddressAddressLine;
    string private _postalAddressPostCode;
    string private _postalAddressTown;
    string private _postalAddressCountry;
    string private _signingKey;
    Addresses.AddressSet private _trustedPeers;
    string private _website;

    /*
     * @dev Initializes new instance of a smart contract. Should be called after smart contract deployment.
     *
     * Can be called only once.
     *
     *
     * @param owner Owner of the smart contract.
     *
     * Requirements:
     * - Should not be the zero address.
     *
     *
     * @param initialAdministrators Initial list of Administrators accounts.
     *
     * Requirements:
     * - Should be a list of unique values.
     * - Should not contain the zero address.
     *
     */
    function initialize(
        address owner,
        address[] memory initialAdministrators
    )
        public
        initializer
    {
        Ownable.initialize(owner);

        for(uint256 i = 0; i < initialAdministrators.length; i++) {
            _addAdministrator(initialAdministrators[i]);
        }
    }

    /*
     * @dev Assigns the Administrator role to the specified account.
     *
     * Can be called only by the Owner.
     *
     *
     * @param account An account to assign the Administrator role to.
     *
     * Requirements:
     * - Should not be the zero address.
     * - Should not has the Administrator role.
     *
     */
    function addAdministrator(
        address account
    )
        public
        onlyOwner
    {
        _addAdministrator(account);
    }

    /*
     * @dev Adds the specified channel to the list of communication channels the VASP accepting for messages.
     *
     * Can be called only by an account with the Administrator role.
     *
     * @param channel Channel type to add to the channels list.
     *
     * Requirements:
     * - Should not be presented in the channels list.
     *
     */
    function addChannel(
        uint8 channel
    )
        external
        onlyAdministrator
    {
        _addChannel(channel);
    }

    /*
     * @dev Adds the specified address to the list of identity claims.
     *
     * Can be called only by an account with the Administrator role.
     *
     * @param identityClaim Address of the identity claim to add to the identity claims list.
     *
     * Requirements:
     * - Should not be the zero address.
     * - Should not be presented in the identity claims list.
     *
     */
    function addIdentityClaim(
        address identityClaim
    )
        external
        onlyAdministrator
    {
        _addIdentityClaim(identityClaim);
    }

    /*
     * @dev Adds the specified address to the list of trusted peers.
     *
     * Can be called only by an account with the Administrator role.
     *
     * @param trustedPeer Address of the trusted peer to add to the trusted peers list.
     *
     * Requirements:
     * - Should not be the zero address.
     * - Should not be presented in the trusted peers list.
     *
     */
    function addTrustedPeer(
        address trustedPeer
    )
        external
        onlyAdministrator
    {
        _addTrustedPeer(trustedPeer);
    }

    /*
     * @dev Revokes the Administrator role from the specified account.
     *
     * Can be called only by the Owner.
     *
     *
     * @param account An account to revoke the Administrator role from.
     *
     * Requirements:
     * - Should not be the zero address.
     * - Should not has the Administrator role.
     *
     */
    function removeAdministrator(
        address account
    )
        public
        onlyOwner
    {
        _removeAdministrator(account);
    }

    /*
     * @dev Removes the specified channel from the list of communication channels the VASP accepting for messages.
     *
     * Can be called only by an account with the Administrator role.
     *
     * @param channel Channel type to remove from the channels list.
     *
     * Requirements:
     * - Should be presented in the channels list.
     *
     */
    function removeChannel(
        uint8 channel
    )
        external
        onlyAdministrator
    {
        _removeChannel(channel);
    }

    /*
     * @dev Removes the specified address from the list of identity claims.
     *
     * Can be called only by an account with the Administrator role.
     *
     * @param identityClaim Address of the identity claim to remove from the identity claims list.
     *
     * Requirements:
     * - Should not be the zero address.
     * - Should be presented in the identity claims list.
     *
     */
    function removeIdentityClaim(
        address identityClaim
    )
        external
        onlyAdministrator
    {
        _removeIdentityClaim(identityClaim);
    }

    /*
     * @dev Removes the specified address from the list of trusted peers.
     *
     * Can be called only by an account with the Administrator role.
     *
     * @param trustedPeer Address of the trusted peer to remove from the trusted peers list.
     *
     * Requirements:
     * - Should not be the zero address.
     * - Should be presented in the trusted peers list.
     *
     */
    function removeTrustedPeer(
        address trustedPeer
    )
        external
        onlyAdministrator
    {
        _removeTrustedPeer(trustedPeer);
    }

    /*
     * @dev Sets the e-mail address of the VASP.
     *
     *
     * @param email New e-mail address value
     *
     * Requirements:
     * - Should not be an empty string.
     * - Should not be equal to the current e-mail.
     *
     */
    function setEmail(
        string calldata email
    )
        external
        onlyAdministrator
    {
        _setEmail(email);
    }

    /*
     * @dev Sets the handshake key.
     *
     *
     * @param handshakeKey New handshake key value
     *
     * Requirements:
     * - Should not be an empty string.
     * - Should not be equal to the current handshake key.
     *
     */
    function setHandshakeKey(
        string calldata handshakeKey
    )
        external
        onlyAdministrator
    {
        _setHandshakeKey(handshakeKey);
    }

    /*
     * @dev Sets the VASP legal name.
     *
     *
     * @param name New name value
     *
     * Requirements:
     * - Should not be an empty string.
     * - Should not be equal to the current name.
     *
     */
    function setName(
        string calldata name
    )
        external
        onlyAdministrator
    {
        _setName(name);
    }

    /*
     * @dev Sets the VASP postal address.
     */
    function setPostalAddress(
        string calldata streetName,
        string calldata buildingNumber,
        string calldata postCode,
        string calldata town,
        string calldata country
    )
        external
        onlyAdministrator
    {
        require(!streetName.isEmpty(), "VASP: street name is not specified");
        require(!buildingNumber.isEmpty(), "VASP: building number is not specified");

        _setPostalAddress(streetName, buildingNumber, /* addressLine */ "", postCode, town, country);
    }

    /*
     * @dev Sets the VASP postal address.
     */
    function setPostalAddress(
        string calldata addressLine,
        string calldata postCode,
        string calldata town,
        string calldata country
    )
        external
        onlyAdministrator
    {
        require(!addressLine.isEmpty(), "VASP: address line is not specified");

        _setPostalAddress(/* streetName */ "", /* buildingNumber */ "", addressLine, postCode, town, country);
    }

    /*
     * @dev Sets the signing key.
     *
     *
     * @param signingKey New signing key value
     *
     * Requirements:
     * - Should not be an empty string.
     * - Should not be equal to the current signing key.
     *
     */
    function setSigningKey(
        string calldata signingKey
    )
        external
        onlyAdministrator
    {
        _setSigningKey(signingKey);
    }

    /**
     * @dev Sets the url of the website of the VASP.
     *
     *
     * @param website New website url
     *
     * Requirements:
     * - Should not be an empty string.
     * - Should not be equal to the current website url.
     *
     */
    function setWebsite(
        string calldata website
    )
        external
        onlyAdministrator
    {
        _setWebsite(website);
    }

    /**
     * @dev See {IVASP-channels}.
     */
    function channels(
        uint256 skip,
        uint256 take
    )
        external view
        returns (uint8[] memory)
    {
        return _channels.toArray(skip, take);
    }

    /**
     * @dev See {IVASP-channelsCount}.
     */
    function channelsCount()
        external view
        returns (uint256)
    {
        return _channels.count();
    }

    /**
     * @dev See {IVASP-code}.
     */
    function code()
        external view
        returns (bytes4)
    {
        bytes memory addressBytes = abi.encodePacked(address(this));

        bytes4 result;
        bytes4 x = bytes4(0xff000000);

        result ^= (x & addressBytes[16]) >> 0;
        result ^= (x & addressBytes[17]) >> 8;
        result ^= (x & addressBytes[18]) >> 16;
        result ^= (x & addressBytes[19]) >> 24;

        return result;
    }

    /**
     * @dev See {IVASP-email}.
     */
    function email()
        external view
        returns (string memory)
    {
        return _email;
    }

    /**
     * @dev See {IVASP-handshakeKey}.
     */
    function handshakeKey()
        external view
        returns (string memory)
    {
        return _handshakeKey;
    }

    /**
    * @dev See {IVASP-identityClaims}.
    */
    function identityClaims(
        uint256 skip,
        uint256 take
    )
        external view
        returns (address[] memory)
    {
        return _identityClaims.toArray(skip, take);
    }

    /**
     * @dev See {IVASP-identityClaimsCount}.
     */
    function identityClaimsCount()
        external view
        returns (uint256)
    {
        return _identityClaims.count();
    }

    /**
     * @dev See {IVASP-name}.
     */
    function name()
        external view
        returns (string memory)
    {
        return _name;
    }

    /**
     * @dev See {IVASP-postalAddress}.
     */
    function postalAddress()
        external view
        returns (
            string memory streetName,
            string memory buildingNumber,
            string memory addressLine,
            string memory postCode,
            string memory town,
            string memory country
        )
    {
        streetName = _postalAddressStreetName;
        buildingNumber = _postalAddressBuildingNumber;
        addressLine = _postalAddressAddressLine;
        postCode = _postalAddressPostCode;
        town = _postalAddressTown;
        country = _postalAddressCountry;
    }

    /**
     * @dev See {IVASP-signingKey}.
     */
    function signingKey()
        external view
        returns (string memory)
    {
        return _signingKey;
    }

    /**
     * @dev See {IVASP-trustedPeers}.
     */
    function trustedPeers(
        uint256 skip,
        uint256 take
    )
        external view
        returns (address[] memory)
    {
        return _trustedPeers.toArray(skip, take);
    }

    /**
     * @dev See {IVASP-trustedPeersCount}.
     */
    function trustedPeersCount()
        external view
        returns (uint256)
    {
        return _trustedPeers.count();
    }

    /**
     * @dev See {IVASP-website}.
     */
    function website()
        external view
        returns (string memory)
    {
        return _website;
    }

    function _addChannel(
        uint8 channel
    )
        private
    {
        _channels.add(channel);

        emit ChannelAdded(channel);
    }

    function _addIdentityClaim(
        address identityClaim
    )
        private
    {
        require(!identityClaim.isZeroAddress(), "VASP: identity claim is the zero address");

        _identityClaims.add(identityClaim);

        emit IdentityClaimAdded(identityClaim);
    }

    function _addTrustedPeer(
        address trustedPeer
    )
        private
    {
        require(!trustedPeer.isZeroAddress(), "VASP: trusted peer is the zero address");

        _trustedPeers.add(trustedPeer);

        emit TrustedPeerAdded(trustedPeer);
    }

    function _removeChannel(
        uint8 channel
    )
        private
    {
        _channels.remove(channel);

        emit ChannelRemoved(channel);
    }

    function _removeIdentityClaim(
        address identityClaim
    )
        private
    {
        require(!identityClaim.isZeroAddress(), "VASP: identity claim is the zero address");

        _identityClaims.remove(identityClaim);

        emit IdentityClaimRemoved(identityClaim);
    }

    function _removeTrustedPeer(
        address trustedPeer
    )
        private
    {
        require(!trustedPeer.isZeroAddress(), "VASP: trusted peer is the zero address");

        _trustedPeers.remove(trustedPeer);

        emit TrustedPeerRemoved(trustedPeer);
    }

    function _setEmail(
        string memory newEmail
    )
        private
    {
        require(!newEmail.isEmpty(), "VASP: newEmail is an empty string");
        require(!newEmail.equals(_email), "VASP: specified e-mail has already been set");

        _email = newEmail;

        emit EmailChanged(newEmail);
    }

    function _setHandshakeKey(
        string memory newHandshakeKey
    )
        private
    {
        require(!newHandshakeKey.isEmpty(), "VASP: newHandshakeKey is an empty string");
        require(!newHandshakeKey.equals(_handshakeKey), "VASP: specified handshake key has already been set");

        _handshakeKey = newHandshakeKey;

        emit HandshakeKeyChanged(newHandshakeKey);
    }

    function _setName(
        string memory newName
    )
        private
    {
        require(!newName.isEmpty(), "VASP: newName is an empty string");
        require(!newName.equals(_name), "VASP: specified name has already been set");

        _name = newName;

        emit NameChanged(newName);
    }

    function _setSigningKey(
        string memory newSigningKey
    )
        private
    {
        require(!newSigningKey.isEmpty(), "VASP: newSigningKey is an empty string");
        require(!newSigningKey.equals(_signingKey), "VASP: specified signing key has already been set");

        _signingKey = newSigningKey;

        emit SigningKeyChanged(newSigningKey);
    }

    function _setPostalAddress(
        string memory streetName,
        string memory buildingNumber,
        string memory addressLine,
        string memory postCode,
        string memory town,
        string memory country
    )
        private
    {
        require(!postCode.isEmpty(), "VASP: post code is not specified");
        require(!town.isEmpty(), "VASP: town is not specified");
        require(!country.isEmpty(), "VASP: country is not specified");

        bool postalAddressChanged =
            !streetName.equals(_postalAddressStreetName) ||
            !buildingNumber.equals(_postalAddressBuildingNumber) ||
            !addressLine.equals(_postalAddressAddressLine) ||
            !postCode.equals(_postalAddressPostCode) ||
            !town.equals(_postalAddressTown) ||
            !country.equals(_postalAddressCountry);

        require(postalAddressChanged, "VASP: specified postal address has already been set");

        _postalAddressStreetName = streetName;
        _postalAddressBuildingNumber = buildingNumber;
        _postalAddressAddressLine = addressLine;
        _postalAddressPostCode = postCode;
        _postalAddressTown = town;
        _postalAddressCountry = country;

        emit PostalAddressChanged(streetName, buildingNumber, addressLine, postCode, town, country);
    }

    function _setWebsite(
        string memory newWebsite
    )
        private
    {
        require(!newWebsite.isEmpty(), "VASP: newWebsite is an empty string");
        require(!newWebsite.equals(_website), "VASP: specified website has already been set");

        _website = newWebsite;

        emit WebsiteChanged(newWebsite);
    }

    // Reserved storage space to allow for layout changes in the future.
    uint256[50] private ______gap;
}
