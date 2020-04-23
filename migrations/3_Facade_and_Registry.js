const VaspFactory = artifacts.require("VaspFactory");
const VaspBuilder = artifacts.require("VaspBuilder");
const VaspFacade = artifacts.require("VaspFacade");
const VaspRegistry = artifacts.require("VaspRegistry");

module.exports =  async function(deployer, network, accounts) {
  await deployer.deploy(VaspFactory);
  factory = await VaspFactory.deployed();
  
  await deployer.deploy(VaspBuilder);
  builder = await VaspBuilder.deployed();
  builder.initialize(factory.address);
  
  
  /*
  // if vasp regestry and vasp facade not deployed to network then uncomment this block
  
  await deployer.deploy(VaspRegistry);
  registry = await VaspRegistry.deployed();

  await deployer.deploy(VaspFacade);
  facade = await VaspFacade.deployed();
  facade.initialize("0x6e2C46e530BDc7Ace969947B71f92bc835fdFCC3");
  facade.setRegestry(registry.address);

  await deployer.deploy(VaspRegistry);
  */
  
  if (network == "ropsten")
  {
    if (accounts[0] == "0x6e2C46e530BDc7Ace969947B71f92bc835fdFCC3")
    {
      facade = await VaspFacade.at("0xB838Ef6121b8093f425fDC336d59E1142c2E289c");
      await facade.setBuilder(builder.address);
    }
  }
};