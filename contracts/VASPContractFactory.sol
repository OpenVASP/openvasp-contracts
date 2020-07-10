//SPDX-License-Identifier: MIT

pragma solidity 0.6.10;

import "./VASPContract.sol";

contract VASPContractFactory {

    function create
    (
        bytes4 vaspCode,
        address owner,
        bytes4 channels,
        string memory transportKey,
        string memory messageKey,
        string memory signingKey
    )
        external
        returns (address)
    {
        VASPContract vaspContract = new VASPContract(vaspCode, owner, channels, transportKey, messageKey, signingKey);
        address vaspAddress = address(vaspContract);

        return vaspAddress;
    }
}