(async () => {
  const opModule = require('./../operations/init');

  exports.command = 'init';
  exports.desc = 'Init';
  exports.builder = opModule.builder;
  exports.handler = async function (argv: InitArgv ) {
    const op = opModule.handle;
    await op(argv);
  };
})();
