(async () => {
  const opModule = require('./../../operations/packer/destroy');

  exports.command = 'packer:destroy';
  exports.desc = 'Packer destroy build';
  exports.builder = opModule.builder;
  exports.handler = async function (argv: VagrantMachineProvisionAddArgv) {
      const op = opModule.handle;
      await op(argv);
  };
})();
