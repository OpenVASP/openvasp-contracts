//SPDX-License-Identifier: MIT

pragma solidity ^0.6.8;

contract VASP {
    string private _handshakeKey;
    address private _owner;
    address private _ownerCandidate;
    string private _signingKey;

    event HandshakeKeySet(string handshakeKey);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event OwnershipTransferRequested(address indexed currentOwner, address indexed candidateOwner);
    event SigningKeySet(string signingKey);

    constructor(address owner) public {
        require(owner != address(0), "VASP: owner is the zero address.");

        _owner = owner;

        emit OwnershipTransferred(owner, address(0));
    }

    modifier onlyOwner() {
        require(_owner == msg.sender, "VASP: caller is not the owner");
        _;
    }

    function acceptOwnership() public {
        require(_ownerCandidate == msg.sender, "VASP: caller is not the owner-candidate");

        address previousOwner = _owner;
        address newOwner = _ownerCandidate;

        _owner = _ownerCandidate;
        _ownerCandidate = address(0);

        emit OwnershipTransferred(previousOwner, newOwner);
    }

    function setHandshakeKey(string memory newHandshakeKey) public onlyOwner {
        _handshakeKey = newHandshakeKey;

        emit HandshakeKeySet(_handshakeKey);
    }

    function setSigningKey(string memory newSigningKey) public onlyOwner {
        _signingKey = newSigningKey;

        emit SigningKeySet(_signingKey);
    }

    function transferOwnership(address ownerCandidate) public onlyOwner {
        require(ownerCandidate != address(0), "VASP: owner-candidate is the zero address");

        _ownerCandidate = ownerCandidate;

        emit OwnershipTransferRequested(_owner, _ownerCandidate);
    }

    function handshakeKey() public view returns (string memory) {
        return _handshakeKey;
    }

    function signingKey() public view returns (string memory) {
        return _signingKey;
    }
}