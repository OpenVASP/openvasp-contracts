pragma solidity ^0.5.0;

import "@openzeppelin/contracts-ethereum-package/contracts/access/Roles.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/GSN/Context.sol";
import "@openzeppelin/upgrades/contracts/Initializable.sol";
import "./IAdministratorRole.sol";

contract AdministratorRole is Initializable, Context, IAdministratorRole {
    using Roles for Roles.Role;


    event AdministratorAdded(
        address indexed account
    );

    event AdministratorRemoved(
        address indexed account
    );


    Roles.Role private _administrators;

    function initialize(
        address sender
    )
        public initializer
    {
        if (!isAdministrator(sender))
        {
            _addAdministrator(sender);
        }
    }

    modifier onlyAdministrator() {
        require(isAdministrator(_msgSender()), "AdministratorRole: caller does not have the Administrator role");
        _;
    }

    function isAdministrator(
        address account
    )
        public view
        returns (bool)
    {
        return _administrators.has(account);
    }

    function addAdministrator(
        address account
    )
        public onlyAdministrator
    {
        _addAdministrator(account);
    }

    function renounceAdministrator()
        public
    {
        _removeAdministrator(_msgSender());
    }

    function _addAdministrator(
        address account
    )
        internal
    {
        _administrators.add(account);
        emit AdministratorAdded(account);
    }

    function _removeAdministrator(
        address account
    )
        internal
    {
        _administrators.remove(account);
        emit AdministratorRemoved(account);
    }

    // Reserved storage space to allow for layout changes in the future.
    uint256[50] private ______gap;
}
