(async () => {
    const opModule = require('./../../../operations/vagrant/init');
  
    exports.command = 'vagrant:init';
    exports.desc = 'Vagrant init';
    exports.builder = opModule.builder;
    exports.handler = async function (argv: VagrantInitArgv) {
      const op = opModule.handle;
      await op(argv);
    };
  })();
  