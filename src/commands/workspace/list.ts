exports.command = 'workspace:list'
exports.desc = 'List workspaces'
exports.builder = {

}
exports.handler = function (argv:any) {
    console.log(exports.command, argv);
}