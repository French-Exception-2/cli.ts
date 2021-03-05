exports.command = 'workspace:get'
exports.desc = 'Get current workspace'
exports.builder = {

}
exports.handler = function (argv:any) {
    console.log(exports.command, argv);
}