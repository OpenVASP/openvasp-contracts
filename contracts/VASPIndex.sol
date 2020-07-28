//SPDX-License-Identifier: MIT

pragma solidity 0.6.12;

import "@openzeppelin/contracts/utils/Pausable.sol";
import "./access/OwnerRole.sol";
import "./VASPContractFactory.sol";

contract VASPIndex is Pausable, OwnerRole {
    mapping (bytes4 => address) private _vaspAddresses;
    mapping (address => bytes4) private _vaspCodes;
    VASPContractFactory private _vaspContractFactory;

    event VASPContractCreated(bytes4 indexed vaspCode, address indexed vaspAddress);

    modifier onlyVASPContract() {
        require(_vaspCodes[_msgSender()] == bytes4(0), "VASPIndex: caller is not a VASP contract");
        _;
    }

    constructor
    (
        address owner,
        address vaspContractFactory
    )
        public
        OwnerRole(owner)
    {
        require(vaspContractFactory != address(0), "VASPIndex: vaspContractFactory is the zero address");

        _vaspContractFactory = VASPContractFactory(vaspContractFactory);
    }

    function createVASPContract
    (
        bytes4 vaspCode,
        address owner,
        bytes4 channels,
        bytes calldata transportKey,
        bytes calldata messageKey,
        bytes calldata signingKey
    )
        external
        whenNotPaused
        returns (address)
    {
        require(vaspCode != bytes4(0), "VASPIndex: vaspCode is empty");
        require(_vaspAddresses[vaspCode] == address(0), "VASPIndex: vaspCode is already in use");

        address vaspAddress = _vaspContractFactory.create(vaspCode, owner, channels, transportKey, messageKey, signingKey);

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
        bytes4 vaspCode
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
        returns (bytes4)
    {
        return _vaspCodes[vaspAddress];
    }
}