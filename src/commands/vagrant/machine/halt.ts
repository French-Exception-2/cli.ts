(async () => {
    const opModule = require('./../../../operations/vagrant/machine/halt');
  
    exports.command = 'vagrant:machine:halt';
    exports.desc = 'Vagrant halt a machine';
    exports.builder = opModule.builder;
    exports.handler = async function (argv: VagrantMachineHaltArgv) {
        const op = opModule.handle;
        await op(argv);
    };
  })();
