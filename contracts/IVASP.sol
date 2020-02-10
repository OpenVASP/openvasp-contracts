pragma solidity ^0.5.0;

/**
 * @title VASP Identity Contract Interface
 */
interface IVASP {

    /**
     * @dev Emitted when the communication channel with a `channel` type added to the channels list.
     */
    event ChannelAdded(
        uint8 channel
    );

    /**
     * @dev Emitted when the communication channel with a `channel` type removed from the channels list.
     */
    event ChannelRemoved(
        uint8 channel
    );

    /**
     * @dev Emitted when the e-mail address of the VASP changed to `email`.
     */
    event EmailChanged(
        string email
    );

    /**
     * @dev Emitted when the handshake key of the VASP changed to `handshakeKey`.
     */
    event HandshakeKeyChanged(
        string handshakeKey
    );

    /**
     * @dev Emitted when the identity claim with a `identityClaim` address added to the identity claims list.
     */
    event IdentityClaimAdded(
        address indexed identityClaim
    );

    /**
     * @dev Emitted when the identity claim with a `identityClaim` address removed from the identity claims list.
     */
    event IdentityClaimRemoved(
        address indexed identityClaim
    );

    /**
     * @dev Emitted when the name of the VASP changed to `name`.
     */
    event NameChanged(
        string name
    );

    /**
     * @dev Emitted when at least one of the postal address parts changed.
     */
    event PostalAddressChanged(
        string streetName,
        string buildingNumber,
        string addressLine,
        string postCode,
        string town,
        string country
    );

    /**
     * @dev Emitted when the trusted peer with a `trustedPeer` address added to the trusted peers list.
     */
    event TrustedPeerAdded(
        address indexed trustedPeer
    );

    /**
     * @dev Emitted when the trusted peer with a `trustedPeer` address from the trusted peers list.
     */
    event TrustedPeerRemoved(
        address indexed trustedPeer
    );

    /**
     * @dev Emitted when the signing key of the VASP changed to `signingKey`.
     */
    event SigningKeyChanged(
        string signingKey
    );

    /**
     * @dev Emitted when the website url of the VASP changed to `website`.
     */
    event WebsiteChanged(
        string website
    );

    /**
     * @dev Gets the list of communication channels the VASP accepting for messages.
     *
     * NB! When you are requesting multiple pages via JSON RPC, pass the same block number parameter for each request.
     *
     * @param skip The number of channels to skip before returning the remaining channels.
     * @param take The number of channels to return.
     *
     * @return An array containing communication channels the VASP accepting for messages.
     */
    function channels(
        uint256 skip,
        uint256 take
    )
        external view
        returns (uint8[] memory);

    /**
     * @dev Gets the number of communication channels the VASP accepting for messages.
     *
     * NB! When are requesting multiple pages via JSON RPC, pass the same block number parameter for each request.
     *
     * @return The number of communication channels the VASP accepting for messages.
     */
    function channelsCount()
        external view
        returns (uint256);

    /**
     * @dev Gets the code of the VASP. VASP code is an array of the last 32 bits of the VASP contract address.
     *
     * @return The code of the VASP.
     */
    function code()
        external view
        returns (bytes4);

    /**
     * @dev Get the e-mail address of the VASP.
     *
     * @return The e-mail address of the VASP.
     */
    function email()
        external view
        returns (string memory);

    /**
     * @dev Gets the handshake key. Handshake key is an asymmetric public key used to securely establish sessions.
     *
     * @return The handshake key.
     */
    function handshakeKey()
        external view
        returns (string memory);

    /**
     * @dev Gets the list of identity claims.
     *
     * NB! When you are requesting multiple pages via JSON RPC, pass the same block number parameter for each request.
     *
     * @param skip The number of identity claims to skip before returning the remaining identity claims.
     * @param take The number of identity claims to return.
     *
     * @return An array containing addresses of the identity claims.
     */
    function identityClaims(
        uint256 skip,
        uint256 take
    )
        external view
        returns (address[] memory);

    /**
     * @dev Gets the number of identity claims.
     *
     * NB! When you are requesting multiple pages via JSON RPC, pass the same block number parameter for each request.
     *
     * @return The number of identity claims.
     */
    function identityClaimsCount()
        external view
        returns (uint256);

    /**
     * @dev Gets the legal name of the VASP.
     *
     * @return The legal name of the VASP.
     */
    function name()
        external view
        returns (string memory);

    /**
     * @dev Gets the postal address of the VASP.
     *
     * @return The postal address of the VASP.
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
        );

    /**
     * @dev Gets the signing key. Signing key is an asymmetric public key used to verify message signatures.
     *
     * @return The signing key.
     */
    function signingKey()
        external view
        returns (string memory);


    /**
     * @dev Gets the list of trusted peer VASPs.
     *
     * NB! When you are requesting multiple pages via JSON RPC, pass the same block number parameter for each request.
     *
     * @param skip The number of trusted peers to skip before returning the remaining trusted peers.
     * @param take The number of trusted peers to return.
     *
     * @return An array containing addresses of the trusted peer VASPs.
     */
    function trustedPeers(
        uint256 skip,
        uint256 take
    )
        external view
        returns (address[] memory);

    /**
     * @dev Gets the number of trusted peer VASPs.
     *
     * NB! When you are requesting multiple pages via JSON RPC, pass the same block number parameter for each request.
     *
     * @return The number of trusted peer VASPs.
     */
    function trustedPeersCount()
        external view
        returns (uint256);

    /**
     * @dev Gets the url of the website of the VASP.
     *
     * @return The url of the website of the VASP.
     */
    function website()
        external view
        returns (string memory);
}
