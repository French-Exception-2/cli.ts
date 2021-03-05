(() => {
    exports.command = 'project:add <directory>'
    exports.desc = 'Add an existing directory as a project into current workspace'
    exports.builder = {
    
    }
    exports.handler = function (argv:any) {
      console.log(exports.command, argv);
    }
  })()