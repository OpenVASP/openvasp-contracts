//SPDX-License-Identifier: MIT

pragma solidity 0.6.10;

import "@openzeppelin/contracts/access/AccessControl.sol";

abstract contract OwnerRole is AccessControl {

    address private _newOwnerCandidate;

    bytes32 public constant OWNER_ROLE = keccak256("OWNER_ROLE");

    event OwnerRoleTransferCancelled();
    event OwnerRoleTransferCompleted(address indexed previousOwner, address indexed newOwner);
    event OwnerRoleTransferStarted(address indexed currentOwner, address indexed newOwnerCandidate);


    modifier onlyOwner() {
        require(hasRole(OWNER_ROLE, _msgSender()), "OwnerRole: caller is not the owner");
        _;
    }

    modifier onlyNewOwnerCandidate() {
        require(_msgSender() == _newOwnerCandidate, "OwnerRole: caller is not the new owner candidate");
        _;
    }

    constructor
    (
        address owner
    )
        internal
    {
        require(owner != address(0), "OwnerRole: owner is the zero address");

        _setupRole(OWNER_ROLE, owner);
        _setRoleAdmin(OWNER_ROLE, OWNER_ROLE);
    }

    function acceptOwnerRole()
        external
        onlyNewOwnerCandidate
    {
        address previousOwner = getRoleMember(OWNER_ROLE, 0);
        address newOwner = _newOwnerCandidate;

        _setupRole(OWNER_ROLE, newOwner);
        revokeRole(OWNER_ROLE, previousOwner);
        _newOwnerCandidate = address(0);

        emit OwnerRoleTransferCompleted(previousOwner, newOwner);
    }

    function cancelOwnerRoleTransfer()
        external
        onlyOwner
    {
        require(_newOwnerCandidate != address(0), "OwnerRole: ownership transfer is not in-progress");

        _cancelOwnerRoleTransfer();
    }

    function renounceOwnerRole() 
        external
    {
        renounceRole(OWNER_ROLE, _msgSender());
        _cancelOwnerRoleTransfer();
    }

    function transferOwnerRole
    (
        address newOwnerCandidate
    )
        external
        onlyOwner
    {
        require(newOwnerCandidate != address(0), "OwnerRole: newOwnerCandidate is the zero address");

        address currentOwner = getRoleMember(OWNER_ROLE, 0);

        require(currentOwner != newOwnerCandidate, "OwnerRole: newOwnerCandidate is the current owner");

        _cancelOwnerRoleTransfer();
        _newOwnerCandidate = newOwnerCandidate;

        emit OwnerRoleTransferStarted(currentOwner, newOwnerCandidate);
    }

    function _cancelOwnerRoleTransfer()
        private
    {
        if (_newOwnerCandidate != address(0)) {
            _newOwnerCandidate = address(0);
            
            emit OwnerRoleTransferCancelled();
        }
    }
}