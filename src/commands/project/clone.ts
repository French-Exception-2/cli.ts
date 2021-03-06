(async () => {
  const opModule = require('./../../operations/project/clone');

  exports.command = 'project:clone';
  exports.desc = 'Project clone';
  exports.builder = opModule.builder;
  exports.handler = async function (argv: ProjectCloneArgv) {
      const op = opModule.handle;
      await op(argv);
  };
})();
