exports.command = 'workspace:set <name>'
exports.desc = 'Set current workspace'
exports.builder = {

}
exports.handler = function (argv:any) {
    console.log(exports.command, argv);
}