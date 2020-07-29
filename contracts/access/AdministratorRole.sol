//SPDX-License-Identifier: MIT

pragma solidity 0.6.12;

import "@openzeppelin/contracts/access/AccessControl.sol";

abstract contract AdministratorRole is AccessControl {

    bytes32 public constant ADMINISTRATOR_ROLE = keccak256("ADMINISTRATOR_ROLE");
    
    modifier onlyAdministrator() {
        require(hasRole(ADMINISTRATOR_ROLE, _msgSender()), "AdministratorRole: caller is not the administrator");
        _;
    }

    constructor
    (
        address administrator,
        bytes32 administratorRoleAdmin
    )
        internal
    {
        require(administrator != address(0), "AdministratorRole: administrator is the zero address");

        _setupRole(ADMINISTRATOR_ROLE, administrator);
        _setRoleAdmin(ADMINISTRATOR_ROLE, administratorRoleAdmin);
    }

    function grantAdministratorRole
    (
        address account
    )
        external
    {
        grantRole(ADMINISTRATOR_ROLE, account);
    }

    function revokeAdministratorRole
    (
        address account
    )
        external
    {
        revokeRole(ADMINISTRATOR_ROLE, account);
    }

    function renounceAdministratorRole()
        external
    {
        renounceRole(ADMINISTRATOR_ROLE, _msgSender());
    }
}