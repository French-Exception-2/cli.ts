exports.command = 'workspace:new <name>'
exports.desc = 'Create a new project in current workspace'
exports.builder = {

}
exports.handler = function (argv:any) {
  console.log('workspace:new', argv);
}