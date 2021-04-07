(async () => {
    const opModule = require('./../../../operations/vagrant/machine/status');
  
    exports.command = 'vagrant:machine:status';
    exports.desc = 'Vagrant machine status';
    exports.builder = opModule.builder;
    exports.handler = async function (argv: VagrantMachineStatusArgv) {
        const op = opModule.handle;
        await op(argv);
    };
  })();
