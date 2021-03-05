exports.command = 'packer:clean'
exports.desc = 'Clean'
exports.builder = {

}
exports.handler = function (argv:any) {
  console.log(exports.command, argv);
}