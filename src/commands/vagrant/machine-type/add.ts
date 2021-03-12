(() => {
  const opModule = require('./../../../operations/vagrant/machine-type/add');

  exports.command = 'vagrant:machine-type:add';
  exports.desc = 'Add new Vagrant Machine Type';
  exports.builder = opModule.builder;
  exports.handler = async function (argv: VagrantMachineTypeAddArgv) {
    const op = opModule.handle;
    await op(argv);
  };
})();