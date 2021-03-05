exports.command = 'project:clone'
exports.desc = 'Clone a project'
exports.builder = {

}
exports.handler = function (argv:any) {
  console.log(exports.command, argv);
}