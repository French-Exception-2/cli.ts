exports.command = 'packer:box <name>'
exports.desc = 'Run Packer'
exports.builder = {

}
exports.handler = function (argv:any) {
  console.log(exports.command, argv);
}