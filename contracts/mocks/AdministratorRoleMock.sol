pragma solidity ^0.5.0;

import "../access/roles/AdministratorRole.sol";

contract AdministratorRoleMock is AdministratorRole {

    function removeAdministratorMock(
        address account
    )
        public
    {
        _removeAdministrator(account);
    }

    function onlyAdministratorMock()
        public view
        onlyAdministrator
    {
    }

    // Causes a compilation error if super._removeAdministrator is not internal
    function _removeAdministrator(
        address account
    )
        internal
    {
        super._removeAdministrator(account);
    }
}