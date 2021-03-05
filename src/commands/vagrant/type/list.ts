exports.command = 'vagrant:type:list'
exports.desc = 'List Vagrant Machine Types'
exports.builder = {

}
exports.handler = function (argv:any) {
  console.log(exports.command, argv);
}