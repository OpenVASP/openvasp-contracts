//SPDX-License-Identifier: MIT

pragma solidity 0.6.10;

import "./access/OwnerRole.sol";

contract VASPContract is OwnerRole {
    bytes4 private _channels;
    string private _transportKey;
    string private _messageKey;
    string private _signingKey;
    bytes8 private _vaspCode;

    event ChannelsChanged(bytes8 indexed vaspCode, bytes4 previousChannels, bytes4 newChannels);
    event TransportKeyChanged(bytes8 indexed vaspCode, string previousTransportKey, string newTransportKey);
    event MessageKeyChanged(bytes8 indexed vaspCode, string previousMessageKey, string newMessageKey);
    event SigningKeyChanged(bytes8 indexed vaspCode, string previousSigningKey, string newSigningKey);

    constructor
    (
        bytes8 vaspCode,
        address owner,
        bytes4 channels,
        string memory transportKey,
        string memory messageKey,
        string memory signingKey
    )
        public
        OwnerRole(owner)
    {
        require(vaspCode != bytes8(0), "VASPContract: vaspCode is empty");

        _vaspCode = vaspCode;

        _setChannels(channels);
        _setTransportKey(transportKey);
        _setMessageKey(messageKey);
        _setSigningKey(signingKey);
    }

    function setChannels
    (
        bytes4 newChannels
    )
        external
        onlyOwner
    {
        _setChannels(newChannels);
    }

    function setTransportKey
    (
        string calldata newTransportKey
    )
        external
        onlyOwner
    {
        _setTransportKey(newTransportKey);
    }

    function setMessageKey
    (
        string calldata newMessageKey
    )
        external
        onlyOwner
    {
        _setMessageKey(newMessageKey);
    }

    function setSigningKey
    (
        string calldata newSigningKey
    )
        external
        onlyOwner
    {
        _setSigningKey(newSigningKey);
    }

    function channels()
        external view
        returns (bytes4)
    {
        return _channels;
    }

    function transportKey()
        external view
        returns (string memory)
    {
        return _transportKey;
    }

    function messageKey()
        external view
        returns (string memory)
    {
        return _messageKey;
    }

    function signingKey()
        external view
        returns (string memory)
    {
        return _signingKey;
    }

    function vaspCode()
        external view
        returns (bytes8)
    {
        return _vaspCode;
    }

    function _setChannels
    (
        bytes4 newChannels
    )
        private
    {
        if(_channels != newChannels) {
            emit ChannelsChanged(_vaspCode, _channels, newChannels);
            _channels = newChannels;
        }
    }

    function _setTransportKey
    (
        string memory newTransportKey
    )
        private
    {
        if(_areNotEqual(_transportKey, newTransportKey)) {
            emit TransportKeyChanged(_vaspCode, _transportKey, newTransportKey);
            _transportKey = newTransportKey;
        }
    }

    function _setMessageKey
    (
        string memory newMessageKey
    )
        private
    {
        if(_areNotEqual(_messageKey, newMessageKey)) {
            emit MessageKeyChanged(_vaspCode, _messageKey, newMessageKey);
            _messageKey = newMessageKey;
        }
    }

    function _setSigningKey
    (
        string memory newSigningKey
    )
        private
    {
        if(_areNotEqual(_signingKey, newSigningKey)) {
            emit SigningKeyChanged(_vaspCode, _signingKey, newSigningKey);
            _signingKey = newSigningKey;
        }
    }

    function _areNotEqual
    (
        string memory left,
        string memory right
    )
        private pure
        returns (bool)
    {
        return keccak256(bytes(left)) != keccak256(bytes(right));
    }
}