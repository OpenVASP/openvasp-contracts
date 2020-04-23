pragma solidity ^0.5.0;

interface IVaspBuilder {

    function build
        (
            string calldata name,
            string calldata handshakeKey,
            string calldata signingKey,
            string calldata email,
            string calldata website
        ) external returns(address);

}