//SPDX-License-Identifier: MIT

pragma solidity 0.6.10;

abstract contract VASPRegistry {

    function getCredentialsRef
    (
        bytes4 vaspCode
    )
        external virtual view
        returns (string memory credentialsRef, bytes32 credentialsHash);

    function validateCredentials
    (
        string calldata credentials,
        bytes32 credentialsHash
    )
        external pure
        returns (bool)
    {
        return  _calculateCredentialsHash(credentials) == credentialsHash;
    }

    function _calculateCredentialsHash
    (
        string memory credentials
    )
        internal pure
        returns (bytes32)
    {
        return keccak256(bytes(credentials));
    }
}