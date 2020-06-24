const { setWorldConstructor } = require('cucumber')

function OpenVASPWorld({ attach, parameters }) {

  this.attach = attach;
  this.contracts = { };
  this.inputs = { };
  this.result = { };
  this.parameters = parameters;
  this.role = null;
}

setWorldConstructor(OpenVASPWorld)