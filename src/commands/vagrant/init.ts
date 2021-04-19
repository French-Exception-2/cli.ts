interface VagrantInitArgv {
  path:string
  status:boolean
  instance:number
  group:string
  provider:string
  config:any
  copy:boolean
}

(async () => {
    exports.command = 'vagrant:init';
    exports.desc = 'Vagrant init';
    exports.builder = ((process) => {
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
    })(process);
    exports.handler = async function (argv: VagrantInitArgv) {
      const fs = require('fs-extra');
      const path = require('path');
      const deepmerge = require('deepmerge');
      const cp = require('child_process');
      const sprintf = require('sprintf-js').sprintf;
    
      await fs.ensureSymlink(path.join(__dirname, '..', '..', '..', '..', 'provisioning'), path.join(argv.path, 'provisioning'));
    
      try {
        if (argv.copy) {
          await fs.copy(path.join(__dirname, '..', '..', '..', '..', 'provisioning'), path.join(argv.path, 'provisioning'));
          await fs.copy(path.join(__dirname, '..', '..', '..', '..', 'resources', 'vagrant_init', 'Vagrantfile'), path.join(argv.path, 'Vagrantfile'));
        } else {
          await fs.ensureSymlink(path.join(__dirname, '..', '..', '..', '..', 'resources', 'vagrant_init', 'Vagrantfile'), path.join(argv.path, 'Vagrantfile'));
          await fs.ensureSymlink(path.join(__dirname, '..', '..', '..', '..', 'provisioning'), path.join(argv.path, 'provisioning'));
        }
      } catch (e) {
        console.error('You might not be authorized to create a symbolic link. Try with option --copy');
        console.error(e);
      }
    
      await fs.writeFile(path.join(argv.path, 'config.json'), JSON.stringify(deepmerge({
        "imports": [
          "./config-local.json"
        ],
        "$": {
    
        },
      }, argv.config), null, 2));
      const configlocal_path = path.join(argv.path, 'config-local.json');
    
      const localConfigDefaults = {
        "$": {
          "vagrant": {
            "group": argv.group,
            "instance": {
              "value": argv.instance,
              "formatted": sprintf('%02d', argv.instance)
            },
            "provider": argv.provider
          }
        }
      }
    
      await fs.writeFile(path.join(argv.path, 'config-local.json'), JSON.stringify(localConfigDefaults, null, 2));
    
      if (argv.status) {
        await cp.spawn("vagrant", ["status"]);
      }
    };
  })();
  