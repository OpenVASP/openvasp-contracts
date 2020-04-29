pragma solidity ^0.5.0;

import "../vasp/VASP.sol";
import "./IVaspFactory.sol";

contract VaspFactory is IVaspFactory {

    function creatVasp(address owner) external returns(address) {

        VASP vasp = new VASP();

        vasp.initialize(owner);

        return address(vasp);
    }
}