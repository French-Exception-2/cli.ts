exports.command = 'project:list <name>'
exports.desc = 'List project instances'
exports.builder = {

}
exports.handler = function (argv:any) {
  console.log(exports.command, argv);
}