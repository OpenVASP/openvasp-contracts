pragma solidity ^0.5.0;

import "@openzeppelin/contracts-ethereum-package/contracts/ownership/Ownable.sol";
import "../vasp/IVASP.sol";
import "./IVaspRegistry.sol";

contract VaspRegistry is IVaspRegistry
{
    mapping (string => address) _vaspByCode;

    event VaspRegistered(address indexed vaspAddress, string indexed vaspCode);

    function getVaspByCode(string calldata vaspCode) external view returns (address)
    {
        return _vaspByCode[vaspCode];
    }

    function registerVasp(address vaspAddress) external
    {
        require(vaspAddress != address(0), "Vasp address cannot ne empty");

        Ownable vasp = Ownable(vaspAddress);
        require(msg.sender == vasp.owner(), "Only owner can register contract in registry");

        string memory code = toCode(vaspAddress);

        require(_vaspByCode[code] == address(0), "Vasp with same VASP code alredy exist in registry");

        _vaspByCode[code] = vaspAddress;

        emit VaspRegistered(vaspAddress, code);
    }

    function toCode(address x) internal pure returns (string memory)
    {
        bytes memory b = new bytes(4);
        for (uint i = 16; i < 20; i++)
            b[i - 16] = byte(uint8(uint(x) / (2**(8*(19 - i)))));
        return string(b);
    }
}