exports.command = 'init'
exports.desc = 'Initialize'
exports.builder = {
  dir: {
    default: '.'
  }
}
exports.handler = function (argv:any) {
  console.log('init called for dir', argv.dir)
}
