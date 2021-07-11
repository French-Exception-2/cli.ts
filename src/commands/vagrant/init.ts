interface VagrantInitArgv {
  path: string
  status: boolean
  instance: number
  group: string
  provider: string
  config: any
  copy: boolean
}

interface VagrantInitRequest extends VagrantInitArgv {

}

interface VagrantInitResponse extends VagrantInitArgv {

}

(async () => {
  exports.command = 'vagrant:init';
  exports.desc = 'Vagrant init';
  exports.builder = ((processCwd: string) => {
    const builder = {
      status: {
        type: "boolean",
        default: false,
        description: "Run `vagrant status` after init"
      },
      instance: {
        type: "number",
        default: 0,
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
      },
      config: {
        type: "object",
        default: {}
      },
      copy: {
        default: false,
        type: "boolean"
      }
    };

    return builder;
  })(process.cwd());
  exports.api = async function (request: VagrantInitRequest, response: VagrantInitResponse) {
    const fs = require('fs-extra');
    const path = require('path');
    const deepmerge = require('deepmerge');
    const cp = require('child_process');
    const sprintf = require('sprintf-js').sprintf;

    await fs.ensureSymlink(path.join(__dirname, '..', '..', '..', '..', 'provision'), path.join(request.path, 'provision'));

    try {
      if (request.copy) {
        await fs.copy(path.join(__dirname, '..', '..', '..', '..', 'provision'), path.join(request.path, 'provision'));
      } else {
        await fs.ensureSymlink(path.join(__dirname, '..', '..', '..', '..', 'provision'), path.join(request.path, 'provision'));
      }
    } catch (e) {
      console.error('You might not be authorized to create a symbolic link. Try with option --copy');
      console.error(e);
    }

    await fs.writeFile(path.join(request.path, 'config.json'), JSON.stringify(deepmerge({
      "imports": [
        "./config-local.json"
      ],
      "$": {

      },
    }, request.config), null, 2));
    const configlocal_path = path.join(request.path, 'config-local.json');

    const localConfigDefaults = {
      "$": {
        "vagrant": {
          "group": request.group,
          "instance": {
            "value": request.instance,
            "formatted": sprintf('%02d', request.instance)
          },
          "provider": request.provider
        }
      }
    }

    await fs.writeFile(path.join(request.path, 'config-local.json'), JSON.stringify(localConfigDefaults, null, 2));

    if (request.status) {
      await cp.spawn("vagrant", ["status"]);
    }

    return response;
  };
  exports.handler = async function (argv: VagrantInitArgv) {
    await exports.api(argv, {});
  };
})();
