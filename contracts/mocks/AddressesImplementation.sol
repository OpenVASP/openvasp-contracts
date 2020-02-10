pragma solidity ^0.5.0;

import "../utils/Addresses.sol";

contract AddressesImplementation {
    using Addresses for Addresses.AddressSet;

    Addresses.AddressSet private _set;

    function add(
        address item
    )
        public
    {
        _set.add(item);
    }

    function remove(
        address item
    )
        public
    {
        _set.remove(item);
    }

    function contains(
        address item
    )
        public view
        returns (bool)
    {
        return _set.contains(item);
    }

    function count()
        public view
        returns (uint256)
    {
        return _set.count();
    }

    function toArray()
        public view
        returns (address[] memory)
    {
        return _set.toArray();
    }

    function toArray(
        uint256 skip,
        uint256 take
    )
        public view
        returns (address[] memory)
    {
        return _set.toArray(skip, take);
    }

    function isZeroAddress(
        address value
    )
        public pure
        returns (bool)
    {
        return Addresses.isZeroAddress(value);
    }
}
