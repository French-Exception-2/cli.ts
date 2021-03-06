(async () => {
  const opModule = require('./../../operations/packer/list');

  exports.command = 'packer:list';
  exports.desc = 'Packer List templates';
  exports.builder = opModule.builder;
  exports.handler = async function (argv: PackerListArgs) {
      const op = opModule.handle;
      await op(argv);
  };
})();
