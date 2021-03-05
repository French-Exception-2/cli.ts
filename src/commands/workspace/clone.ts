exports.command = 'workspace:clone'
exports.desc = 'Clone a workspace'
exports.builder = {

}
exports.handler = function (argv:any) {
  console.log(exports.command, argv);
}