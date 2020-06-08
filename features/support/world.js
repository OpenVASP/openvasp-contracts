const { setWorldConstructor } = require('cucumber')

class OpenVASPWorld {

  constructor() {
      this.constants = {
          EMPTY_VASP_CODE: '0x0000000000000000'
      };
      
      this.contracts = {

      }

      this.inputs = {

      };

      this.state = {

      }
  }

}

setWorldConstructor(OpenVASPWorld)