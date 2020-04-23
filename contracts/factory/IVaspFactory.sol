pragma solidity ^0.5.0;

import "../vasp/IVASP.sol";

interface IVaspFactory {
    event VaspCreated(address indexed newVasp, address indexed owner);

    function creatVasp(address owner) external returns(address);
}