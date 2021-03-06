(async () => {
  const opModule = require('./../../../operations/vagrant/type/add');

  exports.command = 'vagrant:machine-type:list';
  exports.desc = 'Vagrant list types of machines';
  exports.builder = opModule.builder;
  exports.handler = async function (argv: VagrantMachineTypeListArgv) {
    const op = opModule.handle;
    await op(argv);
  };
})();
