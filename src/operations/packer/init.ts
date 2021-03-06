exports.builder = {
    path: {
        type: "string",
        default: process.cwd()
      }
}
exports.handle = async function (argv:PackerInitArgv) {
      const fs = require('fs-extra');
      const path = require('path');
      
      await fs.copy(path.join(__dirname, '..', '..', '..', '..', 'resources', 'vagrant_packer'), path.join(argv.path, '.vagrant'));
      await fs.copy(path.join(__dirname, '..', '..', '..', '..', 'resources', 'packer_init'), argv.path);
}
