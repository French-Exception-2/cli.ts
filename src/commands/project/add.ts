(async () => {
  const opModule = require('./../../operations/project/add');

  exports.command = 'project:add';
  exports.desc = 'Project add an existing directory';
  exports.builder = opModule.builder;
  exports.handler = async function (argv: ProjectAddArgv) {
      const op = opModule.handle;
      await op(argv);
  };
})();
