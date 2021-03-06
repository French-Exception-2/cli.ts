(async () => {
  const opModule = require('./../../operations/project/list');

  exports.command = 'project:list';
  exports.desc = 'Project List projects';
  exports.builder = opModule.builder;
  exports.handler = async function (argv: ProjectListArgv) {
      const op = opModule.handle;
      await op(argv);
  };
})();
