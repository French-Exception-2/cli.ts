(async () => {
  const opModule = require('./../../../operations/vagrant/ssh-config');

  exports.command = 'vagrant:ssh-config';
  exports.desc = 'Vagrant ssh-config';
  exports.builder = opModule.builder;
  exports.handler = async function (argv: VagrantSshConfigArgv) {
    const op = opModule.handle;
    await op(argv);
  };
})();
