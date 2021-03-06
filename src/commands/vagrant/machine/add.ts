(async () => {
    const opModule = require('./../../operations/vagrant/machine/add');
  
    exports.command = 'vagrant:machine:add';
    exports.desc = 'Vagrant add a new machine';
    exports.builder = opModule.builder;
    exports.handler = async function (argv: VagrantMachineProvisionEditArgv) {
        const op = opModule.handle;
        await op(argv);
    };
  })();
