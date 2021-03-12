(async () => {
    const opModule = require('./../../../operations/vagrant/machine/ssh');
  
    exports.command = 'vagrant:machine:ssh';
    exports.desc = 'Vagrant ssh machine';
    exports.builder = opModule.builder;
    exports.handler = async function (argv: VagrantMachineSshArgv) {
        const op = opModule.handle;
        await op(argv);
    };
  })();
