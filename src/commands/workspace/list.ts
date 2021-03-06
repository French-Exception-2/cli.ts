(async () => {
    const opModule = require('./../../../operations/workspace/list');
  
    exports.command = 'workspace:list';
    exports.desc = 'Workspace list';
    exports.builder = opModule.builder;
    exports.handler = async function (argv: WorkspaceListArgv) {
      const op = opModule.handle;
      await op(argv);
    };
  })();
  