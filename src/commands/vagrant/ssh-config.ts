exports.command = 'vagrant:ssh-config'
exports.desc = 'Print ssh-config for machines'
exports.builder = {

}
exports.handler = function (argv:any) {
  console.log(exports.command, argv);
}