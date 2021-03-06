(async () => {
  const opModule = require('./../../operations/packer/add');

  exports.command = 'packer:add';
  exports.desc = 'Packer Add an existing template';
  exports.builder = opModule.builder;
  exports.handler = async function (argv: PackerAddArgv) {
      const op = opModule.handle;
      await op(argv);
  };
})();
