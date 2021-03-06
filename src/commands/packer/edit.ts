(async () => {
  const opModule = require('./../../operations/packer/edit');

  exports.command = 'packer:edit';
  exports.desc = 'Packer edit build file';
  exports.builder = opModule.builder;
  exports.handler = async function (argv: PackerEditArgv) {
      const op = opModule.handle;
      await op(argv);
  };
})();
