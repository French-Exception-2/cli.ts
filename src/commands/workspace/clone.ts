(async () => {
  const opModule = require('./../../../operations/workspace/clone');

  exports.command = 'workspace:clone';
  exports.desc = 'Workspace clone';
  exports.builder = opModule.builder;
  exports.handler = async function (argv: VagrantSshConfigArgv) {
    const op = opModule.handle;
    await op(argv);
  };
})();
