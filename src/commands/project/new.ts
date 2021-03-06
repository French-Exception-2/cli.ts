(async () => {
  const opModule = require('./../../operations/project/new');

  exports.command = 'project:new';
  exports.desc = 'Project New';
  exports.builder = opModule.builder;
  exports.handler = async function (argv: ProjectNewArgv) {
      const op = opModule.handle;
      await op(argv);
  };
})();
