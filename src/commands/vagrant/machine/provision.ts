(async () => {
    const opModule = require('./../../../operations/vagrant/machine/provision');
  
    exports.command = 'vagrant:machine:provision';
    exports.desc = 'Vagrant provision machine';
    exports.builder = opModule.builder;
    exports.handler = async function (argv: VagrantMachineProvisionArgv) {
        const op = opModule.handle;
        await op(argv);
    };
  })();
