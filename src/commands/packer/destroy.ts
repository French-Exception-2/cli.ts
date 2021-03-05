exports.command = 'packer:destroy <name>'
exports.desc = 'Destroy a Packer box instance'
exports.builder = {

}
exports.handler = function (argv:any) {
  console.log(exports.command, argv);
}