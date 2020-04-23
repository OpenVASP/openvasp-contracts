pragma solidity ^0.5.0;

import "@openzeppelin/contracts-ethereum-package/contracts/ownership/Ownable.sol";
import "@openzeppelin/upgrades/contracts/Initializable.sol";
import "./builder/IVaspBuilder.sol";
import "./registry/IVaspRegistry.sol";
import "./IVaspFacade.sol";



contract VaspFacade is Initializable, Ownable, IVaspFacade {

    IVaspBuilder _builder;
    IVaspRegistry _registry;

    function initialize(
        address owner
    )
        public
        initializer
    {
        Ownable.initialize(owner);
    }

    function setBuilder(address builderAddress)
        external
        onlyOwner
    {
        _builder = IVaspBuilder(builderAddress);
    }

    function build
    (
        string memory name,
        string memory handshakeKey,
        string memory signingKey,
        string memory email,
        string memory website
    )
        public
    {
        address vasp = _builder.build(name, handshakeKey, signingKey, email, website);
        _registry.registerVasp(vasp);
    }

    function setRegestry(address regestryAddress)
        public
        onlyOwner
    {
        _registry = IVaspRegistry(regestryAddress);
    }

    function getVaspByCode(string calldata vaspCode) external view returns (address)
    {
        address vasp = _registry.getVaspByCode(vaspCode);
        return vasp;
    }

    function getBuilder()
        public view
        returns (address)
    {
        return address(_builder);
    }

    function getRegistry()
        public view
        returns (address)
    {
        return address(_registry);
    }
}