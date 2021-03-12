(async () => {
    const opModule = require('./../../../operations/vagrant/machine/up');
  
    exports.command = 'vagrant:machine:up';
    exports.desc = 'Vagrant up machine';
    exports.builder = opModule.builder;
    exports.handler = async function (argv: VagrantMachineUpArgv) {
        const op = opModule.handle;
        await op(argv);
    };
  })();
