exports.command = 'packer:edit <name>'
exports.desc = 'Edit a Packer box instance'
exports.builder = {

}
exports.handler = function (argv:any) {
  console.log(exports.command, argv);
}