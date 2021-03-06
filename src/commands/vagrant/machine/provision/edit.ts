(async () => {
    const opModule = require('./../../operations/vagrant/machine/provision/edit');
  
    exports.command = 'vagrant:machine:provision:edit';
    exports.desc = 'Vagrant edit vagrant machine provision script';
    exports.builder = opModule.builder;
    exports.handler = async function (argv: VagrantMachineProvisionEditArgv) {
        const op = opModule.handle;
        await op(argv);
    };
  })();
  