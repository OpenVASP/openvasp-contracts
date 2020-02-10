pragma solidity ^0.5.0;

/**
 * @title Addresses
 * @dev Collection of structs and functions related to address type.
 */
library Addresses {
    struct AddressSet {
        mapping(address => uint256) _indexOf;
        address[] _items;
    }

    /**
     * @dev Adds an address to the set, if set does not contain it.
     * @param item The address to add to the set.
     */
    function add(
        AddressSet storage addresses,
        address item
    )
        internal
    {
        require(!contains(addresses, item), "Addresses: set already contains address");

        addresses._items.push(item);
        addresses._indexOf[item] = count(addresses);
    }

    /**
     * @dev Removes the address from the set, if set contains it.
     * @param item The address to remove from the set.
     */
    function remove(
        AddressSet storage addresses,
        address item
    )
        internal
    {
        require(contains(addresses, item), "Addresses: set does not contain address");

        uint256 index = addresses._indexOf[item] - 1;

        addresses._items[index] = addresses._items[count(addresses) - 1];
        addresses._items.pop();

        delete addresses._indexOf[item];
    }

    /**
     * @dev Check if an address set contains specified address.
     * @param item The address to locate in the set.
     * @return `true` if the address is found in the set, `false` otherwise.
     */
    function contains(
        AddressSet storage addresses,
        address item
    )
        internal view
        returns(bool)
    {
        return addresses._indexOf[item] != 0;
    }

    /**
     * @dev Gets the number of addresses actually contained in the set.
     * @return The number of addresses actually contained in the set.
     */
    function count(
        AddressSet storage addresses
    )
        internal view
        returns (uint256)
    {
        return addresses._items.length;
    }

    function isZeroAddress(
        address value
    )
        internal pure
        returns (bool)
    {
        return value == address(0);
    }

    /**
     * @dev Copies the set to a new array.
     * @return A new array containing copies of the addresses of the set.
     */
    function toArray(
        AddressSet storage addresses
    )
        internal view
        returns (address[] memory)
    {
        return toArray(addresses, 0, count(addresses));
    }

    /**
     * @dev Copies the set to a new array.
     * @param skip The number of addresses to skip before returning the remaining addresses.
     * @param take` The number of addresses to return.
     * @return A new array containing copies of the addresses of the set.
     */
    function toArray(
        AddressSet storage addresses,
        uint256 skip,
        uint256 take
    )
        internal view
        returns (address[] memory)
    {
        uint256 length = take;

        if (length > count(addresses) - skip) {
            length = count(addresses) - skip;
        }

        address[] memory result = new address[](length);

        for (uint256 i = 0; i < length; i++) {
            result[i] = addresses._items[skip + i];
        }

        return result;
    }
}
