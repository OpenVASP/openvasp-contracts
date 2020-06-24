//SPDX-License-Identifier: MIT

pragma solidity 0.6.10;

import "@openzeppelin/contracts/utils/Pausable.sol";
import "./access/OwnerRole.sol";
import "./VASPContract.sol";

contract VASPIndex is Pausable, OwnerRole {
    mapping (bytes8 => address) private _vaspAddresses;
    mapping (address => bytes8) private _vaspCodes;

    event VASPContractCreated(bytes8 indexed vaspCode, address indexed vaspAddress);

    modifier onlyVASPContract() {
        require(_vaspCodes[_msgSender()] == bytes8(0), "VASPIndex: caller is not a VASP contract");
        _;
    }

    constructor
    (
        address owner
    )
        public
        OwnerRole(owner)
    {
    }

    function createVASPContract
    (
        bytes8 vaspCode,
        address owner,
        bytes4 channels,
        string calldata transportKey,
        string calldata messageKey,
        string calldata signingKey
    )
        external
        whenNotPaused
        returns (address)
    {
        require(vaspCode != bytes8(0), "VASPIndex: vaspCode is empty");
        require(_vaspAddresses[vaspCode] == address(0), "VASPIndex: vaspCode is already in use");

        VASPContract vaspContract = new VASPContract(vaspCode, owner, channels, transportKey, messageKey, signingKey);
        address vaspAddress = address(vaspContract);

        _vaspCodes[vaspAddress] = vaspCode;
        _vaspAddresses[vaspCode] = vaspAddress;

        emit VASPContractCreated(vaspCode, vaspAddress);

        return vaspAddress;
    }

    function pause()
        external
        onlyOwner
    {
        _pause();
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

    function unpause()
        external
        onlyOwner
    {
        _unpause();
    }

    function getVASPAddressByCode
    (
        bytes8 vaspCode
    )
        external view
        returns (address)
    {
        return _vaspAddresses[vaspCode];
    }

    function getVASPCodeByAddress
    (
        address vaspAddress
    )
        external view
        returns (bytes8)
    {
        return _vaspCodes[vaspAddress];
    }
}