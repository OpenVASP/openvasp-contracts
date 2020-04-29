const VASP = artifacts.require("VASP");

module.exports = function(deployer) {
  deployer.deploy(VASP);
};