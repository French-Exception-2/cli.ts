exports.command = 'packer:init'
exports.desc = 'Initialize a Packer directory'
exports.builder = {
    path: {
        type: "string",
        default: process.cwd()
      }
}
exports.handler = async function (argv:PackerInitArgv) {
      await fs.copy(path.join(__dirname, '..', '..', '..', '..', 'resources', 'vagrant_packer'), path.join(argv.path, '.vagrant'));
      await fs.copy(path.join(__dirname, '..', '..', '..', '..', 'resources', 'packer_init'), argv.path);
}

interface PackerInitArgv {
    path: string
}