//SPDX-License-Identifier: MIT

pragma solidity 0.6.12;

import "./access/OwnerRole.sol";

contract VASPContract is OwnerRole {
    bytes4 private _channels;
    bytes private _transportKey;
    bytes private _messageKey;
    bytes private _signingKey;
    bytes4 private _vaspCode;

    event ChannelsChanged(bytes4 indexed vaspCode, bytes4 previousChannels, bytes4 newChannels);
    event TransportKeyChanged(bytes4 indexed vaspCode, bytes previousTransportKey, bytes newTransportKey);
    event MessageKeyChanged(bytes4 indexed vaspCode, bytes previousMessageKey, bytes newMessageKey);
    event SigningKeyChanged(bytes4 indexed vaspCode, bytes previousSigningKey, bytes newSigningKey);

    constructor
    (
        bytes4 vaspCode,
        address owner,
        bytes4 channels,
        bytes memory transportKey,
        bytes memory messageKey,
        bytes memory signingKey
    )
        public
        OwnerRole(owner)
    {
        require(vaspCode != bytes4(0), "VASPContract: vaspCode is empty");
        require(_isValidKey(transportKey), "VASPContract: transportKey is invalid");
        require(_isValidKey(messageKey), "VASPContract: messageKey is invalid");
        require(_isValidKey(signingKey), "VASPContract: signingKey is invalid");

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
        bytes calldata newTransportKey
    )
        external
        onlyOwner
    {
        require(_isValidKey(newTransportKey), "VASPContract: newTransportKey is invalid");

        _setTransportKey(newTransportKey);
    }

    function setMessageKey
    (
        bytes calldata newMessageKey
    )
        external
        onlyOwner
    {
        require(_isValidKey(newMessageKey), "VASPContract: newMessageKey is invalid");

        _setMessageKey(newMessageKey);
    }

    function setSigningKey
    (
        bytes calldata newSigningKey
    )
        external
        onlyOwner
    {
        require(_isValidKey(newSigningKey), "VASPContract: newSigningKey is invalid");

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
        returns (bytes memory)
    {
        return _transportKey;
    }

    function messageKey()
        external view
        returns (bytes memory)
    {
        return _messageKey;
    }

    function signingKey()
        external view
        returns (bytes memory)
    {
        return _signingKey;
    }

    function vaspCode()
        external view
        returns (bytes4)
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
        bytes memory newTransportKey
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
        bytes memory newMessageKey
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
        bytes memory newSigningKey
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
        bytes memory left,
        bytes memory right
    )
        private pure
        returns (bool)
    {
        return keccak256(left) != keccak256(right);
    }

    function _isValidKey
    (
        bytes memory key
    )
        private pure
        returns (bool)
    {
        return key.length == 33 && (key[0] == 0x02 || key[0] == 0x03);
    }
}