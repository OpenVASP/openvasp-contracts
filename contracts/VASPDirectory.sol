//SPDX-License-Identifier: MIT

pragma solidity 0.6.12;

import "@openzeppelin/contracts/utils/Strings.sol";
import "./access/AdministratorRole.sol";
import "./access/OwnerRole.sol";
import "./VASPRegistry.sol";


contract VASPDirectory is VASPRegistry, AdministratorRole, OwnerRole {
    using Strings for uint256;

    mapping(bytes6 => bytes32) private _credentialsHashes;

    event CredentialsInserted
    (
        bytes6 indexed vaspId,
        bytes32 indexed credentialsRef,
        bytes32 indexed credentialsHash,
        string credentials
    );

    event CredentialsRevoked
    (
        bytes6 indexed vaspId,
        bytes32 indexed credentialsRef,
        bytes32 indexed credentialsHash
    );


    constructor
    (
        address owner,
        address administrator
    )
        public
        AdministratorRole(administrator, OWNER_ROLE)
        OwnerRole(owner)
    {
    }


    function insertCredentials
    (
        bytes6 vaspId,
        string calldata credentials
    )
        external
        onlyAdministrator
    {
        require(_credentialsHashes[vaspId] == bytes32(0), "VASPDirectory: vaspId has already been registered");

        bytes32 credentialsHash = _calculateCredentialsHash(credentials);

        _credentialsHashes[vaspId] = credentialsHash;

        emit CredentialsInserted(vaspId, credentialsHash, credentialsHash, credentials);
    }

    function revokeCredentials
    (
        bytes6 vaspId
    )
        external
        onlyAdministrator
    {
        bytes32 credentialsHash = _credentialsHashes[vaspId];

        require(credentialsHash != bytes32(0), "VASPDirectory: vaspCode is not registered");

        delete _credentialsHashes[vaspId];

        emit CredentialsRevoked(vaspId, credentialsHash, credentialsHash);
    }

    function terminate
    (
        address payable recipient
    )
        external
        onlyOwner
    {
        selfdestruct(recipient);
    }

    function getCredentialsRef
    (
        bytes6 vaspId
    )
        external override view
        returns (string memory credentialsRef, bytes32 credentialsHash)
    {
        credentialsHash = _credentialsHashes[vaspId];

        if (credentialsHash != bytes32(0)) {
            credentialsRef = _convertBytes32ToHexString(credentialsHash);
        } else {
            credentialsRef = '';
        }

        return (credentialsRef, credentialsHash);
    }

    function _convertBytes32ToHexString
    (
        bytes32 input
    )
        private pure
        returns (string memory)
    {
        bytes memory output = new bytes(66);

        output[0] = '0';
        output[1] = 'x';

        for(uint i = 0; i < 32; i++) {
            uint8 decimalValue = uint8(input[i]);
            output[i * 2 + 2] = _hexChar(decimalValue / 16);
            output[i * 2 + 3] = _hexChar(decimalValue % 16);
        }

        return string(output);
    }

    function _hexChar
    (
        uint8 decimalRepresentation
    )
        private pure
        returns (bytes1)
    {
        require(decimalRepresentation < 16, "VASPDirectory: decimalRepresentation should be lower than 16");

        if (uint8(decimalRepresentation) < 10) {
            return bytes1(decimalRepresentation + 0x30);
        } else {
            return bytes1(decimalRepresentation + 0x57);
        }
    }
}