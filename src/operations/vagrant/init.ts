exports.builder  = {
    status: {
        type: "boolean",
        default: false,
        description: "Run `vagrant status` after init"
      },
      instance: {
        type: "int",
        default: 1,
        description: " Vagrant Instance number"
      },
      group: {
        type: "string",
        default: "Vagrant Instance Group"
      },
      provider: {
        type: "string",
        default: "virtualbox"
      },
      path: {
        type: "string",
        default: process.cwd()
      }
}

exports.handle = async function(argv:VagrantInitArgv) {
  const fs = require('fs-extra');
  const path = require('path');
  const deepmerge = require('deepmerge');
  const cp = require('child_process');
  
  if (! await fs.exists(path.join(argv.path, '.vagrant'))) {
    await fs.mkdir(path.join(argv.path, '.vagrant'));
  }
  
  await fs.copy(path.join(__dirname, '..', '..', '..', '..', 'resources', 'vagrant_packer'), path.join(argv.path, '.vagrant'));
  await fs.copy(path.join(__dirname, '..', '..', '..', '..', 'resources', 'vagrant_init'), argv.path);

  var localConfig = JSON.parse(await fs.readFile(path.join(argv.path, 'config-local.json')));

  const localConfigDefaults = {
    "vagrant": {
      "group": argv.group,
      "instance": argv.instance,
      "provider": argv.provider
    }
  }

  localConfig = deepmerge(localConfig, localConfigDefaults);

  await fs.writeFile(path.join(process.cwd(), 'config-local.json'), JSON.stringify(localConfig, null, 2));

  if (argv.status) {
    await cp.spawn("vagrant", ["status"]);
  }
}