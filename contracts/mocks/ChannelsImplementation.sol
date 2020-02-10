pragma solidity ^0.5.0;

import "../utils/Channels.sol";

contract ChannelsImplementation {
    using Channels for Channels.ChannelSet;

    Channels.ChannelSet private _set;

    function add(
        uint8 item
    )
        public
    {
        _set.add(item);
    }

    function remove(
        uint8 item
    )
        public
    {
        _set.remove(item);
    }

    function contains(
        uint8 item
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
        returns (uint8[] memory)
    {
        return _set.toArray();
    }

    function toArray(
        uint256 skip,
        uint256 take
    )
        public view
        returns (uint8[] memory)
    {
        return _set.toArray(skip, take);
    }
}
