(async () => {
  const opModule = require('./../../operations/packer/clean');

  exports.command = 'packer:clean';
  exports.desc = 'Packer clean builds and artefacts';
  exports.builder = opModule.builder;
  exports.handler = async function (argv: PackerCleanArgv) {
      const op = opModule.handle;
      await op(argv);
  };
})();
