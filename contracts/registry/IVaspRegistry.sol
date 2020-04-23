pragma solidity ^0.5.0;

interface IVaspRegistry {

    function getVaspByCode(string calldata vaspCode) external view returns (address);
    function registerVasp(address vaspAddress) external;

}