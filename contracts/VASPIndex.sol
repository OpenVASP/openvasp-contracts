//SPDX-License-Identifier: MIT

pragma solidity ^0.6.8;

import "./VASP.sol";

contract VASPIndex {
    mapping (bytes8 => address) private _vaspAddresses;
    mapping (address => bytes8) private _vaspCodes;
    
    event VASPcontractCreated(address indexed vaspAddress, bytes8 vaspCode, bytes8 indexed vaspCodeHash);

    function createVASPContract(address owner, bytes8 vaspCode) public returns (address) {
        require(vaspCode != bytes8(0), "VASPIndex: vaspCode is empty.");
        require(_vaspAddresses[vaspCode] == address(0), "VASPIndex: vaspCode is already in use.");

        VASP vaspContract = new VASP(owner);

        address vaspAddress = address(vaspContract);

        _vaspCodes[vaspAddress] = vaspCode;
        _vaspAddresses[vaspCode] = vaspAddress;

        emit VASPcontractCreated(vaspAddress, vaspCode, vaspCode);

        return vaspAddress;
    }

    function getVASPAddressByCode(bytes8 vaspCode) public view returns (address) {
        return _vaspAddresses[vaspCode];
    }

    function getVASPCodeByAddress(address vaspAddress) public view returns (bytes8) {
        return _vaspCodes[vaspAddress];
    }
}