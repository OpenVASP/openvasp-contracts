//SPDX-License-Identifier: MIT

pragma solidity 0.6.10;

import "@openzeppelin/contracts/utils/Strings.sol";
import "./access/AdministratorRole.sol";
import "./access/OwnerRole.sol";
import "./VASPRegistry.sol";


contract VASPDirectory is VASPRegistry, AdministratorRole, OwnerRole {
    using Strings for uint256;

    mapping(bytes12 => bytes32) private _credentialsHashes;

    event CredentialsInserted(bytes12 indexed vaspId, bytes32 indexed credentialsRef, bytes32 indexed credentialsHash, string credentials);
    event CredentialsRevoked(bytes12 indexed vaspId, bytes32 indexed credentialsRef, bytes32 indexed credentialsHash);


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
        bytes12 vaspId,
        string calldata credentials
    )
        external
        onlyAdministrator
    {
        require(_credentialsHashes[vaspId] == bytes32(0), "VASPDirectory: credentials for the specified vaspId has already been added");

        bytes32 credentialsHash = keccak256(bytes(credentials));

        _credentialsHashes[vaspId] = credentialsHash;

        emit CredentialsInserted(vaspId, credentialsHash, credentialsHash, credentials);
    }

    function revokeCredentials
    (
        bytes12 vaspId
    )
        external
        onlyAdministrator
    {
        require(_credentialsHashes[vaspId] != bytes32(0), "VASPDirectory: credentials for the specified vaspId do not exist");

        bytes32 credentialsHash = _credentialsHashes[vaspId];

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
        bytes12 vaspId
    )
        external override view
        returns (string memory credentialsRef, bytes32 credentialsHash)
    {
        credentialsHash = _credentialsHashes[vaspId];

        return (string(abi.encodePacked(credentialsHash)), credentialsHash);
    }
}