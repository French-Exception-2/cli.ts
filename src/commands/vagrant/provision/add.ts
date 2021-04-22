interface VagrantProvisionAddArgv extends VagrantProvisioning {
    path: string;
    edit: boolean
    provision: VagrantProvisioning
    code: string
}

interface VagrantProvisioning {
    name: string
    "os-type": string
    "os-version": string
    env: Array<string>
    isBash: boolean
    isPosh: boolean
}

(async () => {
    exports.command = 'vagrant:provision:add';
    exports.desc = 'Add new Provisioning';
    exports.builder = ((process) => {
        const builder = {
            name: {
                type: "string",
                required: true,
                description: "Name of Provision",
            },
            env: {
                type: "array",
                description: "ENV Vars as KEY=VALUE",
                default: []
            },
            'os-type': {
                type: 'string',
                default: null,
                description: null
            },
            'os-version': {
                type: 'string',
                default: null,
                description: null
            },
            path: {
                type: "string",
                default: process.cwd(),
            },
            edit: {
                type: 'boolean',
                default: false
            },
            code: {
                type: 'string',
                default: null
            },
            'is-posh': {
                type: 'boolean',
                default: false,
                description: "provided --code is PoSh"
            },
            'is-bash': {
                type: 'boolean',
                default: false,
                description: "provided --code is bash"
            }
        };

        return builder;
    })(process);
    exports.handler = async function (argv: VagrantProvisionAddArgv) {
        console.log('vagrant:provision:add ' + argv.name);
        const deepmerge = require('deepmerge');

        const path = require('path');
        const fs = require('fs-extra');
        const mkdirp = require('mkdirp');
        const _json = require('./../../../Serialization');

        const json_filepath = path.join(argv.path, 'config.json');
        let json = JSON.parse(await fs.readFile(json_filepath));

        const provision: Partial<VagrantProvisioning> = {
            name: argv.name,
            env: argv.env,
            "os-type": argv["os-type"],
            "os-version": argv["os-version"],
            isPosh: argv.isPosh,
            isBash: argv.isBash
        }

        if (null == json['$'].provisioning || undefined == json['$'].provisioning || !Array.isArray(json['$'].provisioning)) {
            json['$'].provisioning = [];
        }

        json['$'].provisioning.push(provision);

        await fs.writeFile(json_filepath, _json.toJson(json));

        if (argv.code && provision["os-type"] && provision["os-version"]) {
            const code = (!provision.isBash ? "#!/usr/bin/env bash" : "#!/usr/bin/env pwsh") + "\r\n" + "\r\n" + argv.code + "\r\n";
            const filepath = path.join(argv.path, 'provisioning', provision["os-type"], provision["os-version"]);

            if (!fs.access(filepath)) {
                await fs.mkdir(filepath, { recursive: true });
            }

            const filename = `${provision.name}.${provision.isBash ? 'sh' : 'ps1'}`;
            const fullpath = path.join(filepath, filename);
            await fs.writeFile(fullpath, code);
        }

        if (argv.edit) {
            const cp = require('child_process');
            await cp.exec('code . -n');
        }
    };
})();
