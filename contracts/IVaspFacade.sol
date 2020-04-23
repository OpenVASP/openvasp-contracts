pragma solidity ^0.5.0;

interface IVaspFacade {

    function setBuilder(address builderAddress)
        external
        //onlyOwner
        ;
}