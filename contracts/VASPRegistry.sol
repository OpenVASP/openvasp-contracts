//SPDX-License-Identifier: MIT

pragma solidity 0.6.10;

abstract contract VASPRegistry {

    function getCredentialsRef
    (
        bytes12 vaspId
    )
        external virtual view
        returns (string memory credentialsRef, bytes32 credentialsHash);

}