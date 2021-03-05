exports.command = 'packer:list'
exports.desc = 'List available Packer boxes'
exports.builder = {

}
exports.handler = function (argv:any) {
  console.log(exports.command, argv);
}