pragma solidity ^0.5.0;

/**
 * @title Strings
 * @dev Collection of functions related to the string type.
 */
library Strings {

    function equals(
        string memory left,
        string memory right
    )
        internal pure
        returns (bool)
    {
        return keccak256(abi.encodePacked(left)) == keccak256(abi.encodePacked(right));
    }

    function isEmpty(
        string memory value
    )
        internal pure
        returns (bool)
    {
        bytes memory valueBytes = bytes(value);

        return valueBytes.length == 0;
    }

}
