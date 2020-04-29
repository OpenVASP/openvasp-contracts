pragma solidity ^0.5.0;

interface IVaspManager {

    function setName(string calldata name) external;

    function setHandshakeKey(string calldata handshakeKey) external;

    function setSigningKey(string calldata signingKey) external;

    function setEmail(string calldata email) external;

    function addChannel(uint8 channel) external;

    function setPostalAddress(
        string calldata streetName,
        string calldata buildingNumber,
        string calldata postCode,
        string calldata town,
        string calldata country
    ) external;

    function setPostalAddressLine(
        string calldata addressLine,
        string calldata postCode,
        string calldata town,
        string calldata country
    ) external;

    function setWebsite(string calldata website) external;
}
