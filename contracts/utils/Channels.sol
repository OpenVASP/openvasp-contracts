pragma solidity ^0.5.0;

/**
 * @title Channels
 * @dev Collection of structs and functions related to communication channels.
 */
library Channels {
    struct ChannelSet {
        mapping(uint8 => uint256) _indexOf;
        uint8[] _items;
    }

    /**
     * @dev Adds a channel to the set, if set does not contain it.
     * @param item The channel to add to the set.
     */
    function add(
        ChannelSet storage channels,
        uint8 item
    )
        internal
    {
        require(!contains(channels, item), "Channels: set already contains the specified channel");

        channels._items.push(item);
        channels._indexOf[item] = count(channels);
    }

    /**
     * @dev Removes the channel from the set, if set contains it.
     * @param item The channel to remove from the set.
     */
    function remove(
        ChannelSet storage channels,
        uint8 item
    )
        internal
    {
        require(contains(channels, item), "Addresses: set does not contain address");

        uint256 index = channels._indexOf[item] - 1;

        channels._items[index] = channels._items[count(channels) - 1];
        channels._items.pop();

        delete channels._indexOf[item];
    }

    /**
     * @dev Check if a channel set contains specified address.
     * @param item The channel to locate in the set.
     * @return `true` if the channel is found in the set, `false` otherwise.
     */
    function contains(
        ChannelSet storage channels,
        uint8 item
    )
        internal view
        returns(bool)
    {
        return channels._indexOf[item] != 0;
    }

    /**
     * @dev Gets the number of channels actually contained in the set.
     * @return The number of channels actually contained in the set.
     */
    function count(
        ChannelSet storage channels
    )
        internal view
        returns (uint256)
    {
        return channels._items.length;
    }

    /**
     * @dev Copies the set to a new array.
     * @return A new array containing copies of the channels of the set.
     */
    function toArray(
        ChannelSet storage channels
    )
        internal view
        returns (uint8[] memory)
    {
        return toArray(channels, 0, count(channels));
    }

    /**
     * @dev Copies the set to a new array.
     * @param skip The number of channels to skip before returning the remaining addresses.
     * @param take The number of channels to return.
     * @return A new array containing copies of the channels of the set.
     */
    function toArray(
        ChannelSet storage channels,
        uint256 skip,
        uint256 take
    )
        internal view
        returns (uint8[] memory)
    {
        uint256 length = take;

        if (length > count(channels) - skip) {
            length = count(channels) - skip;
        }

        uint8[] memory result = new uint8[](length);

        for (uint256 i = 0; i < length; i++) {
            result[i] = channels._items[skip + i];
        }

        return result;
    }
}
