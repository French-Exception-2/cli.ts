exports.command = 'packer:add <name>'
exports.desc = 'Add a Packer box instance'
exports.builder = {

}
exports.handler = function (argv:any) {
  console.log(exports.command, argv);
}