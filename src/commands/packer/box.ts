(async () => {
  const opModule = require('./../../operations/packer/box');

  exports.command = 'packer:box';
  exports.desc = 'Packer run build';
  exports.builder = opModule.builder;
  exports.handler = async function (argv: PackerBoxArgv) {
      const op = opModule.handle;
      await op(argv);
  };
})();
