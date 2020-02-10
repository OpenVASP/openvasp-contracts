pragma solidity ^0.5.0;

import "../utils/Strings.sol";

contract StringsImplementation {

    function equals(
        string memory left,
        string memory right
    )
        public pure
        returns (bool)
    {
        return Strings.equals(left, right);
    }

    function isEmpty(
        string memory value
    )
        public pure
        returns (bool)
    {
        return Strings.isEmpty(value);
    }

}
