interface VagrantProvisionAddArgv extends VagrantMachineArgv {
    edit: boolean
    provision: VagrantProvisioning
    code: string
    'provision-name': string
    'os-type': string
    'os-version': string
    'provision-env': Array<string>
    isBash: boolean
    isPosh: boolean
}

interface VagrantProvisionAddRequest extends VagrantProvisionAddArgv {

}

interface VagrantProvisionAddResponse extends VagrantProvisionAddArgv {

}

interface VagrantProvisioning {
    name: string
    'os-type': string
    'os-version': string
    env: Array<string>
    isBash: boolean
    isPosh: boolean
}

(async () => {
    exports.command = 'vagrant:provision:add';
    exports.desc = 'Add new Provisioning';
    exports.builder = ((processCwd: string) => {
        const builder = {
            'machine-name': {
                type: 'string',
                describe: 'Machine name to associate with provision'
            },
            'machine-instance': {
                type: 'string',
                describe: 'Machine instance to associate with provision'
            },
            'config-env': {
                type: 'string',
                default: 'dev'
            },
            env: {
                type: 'array',
                description: 'ENV Vars as KEY=VALUE',
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
                type: 'string',
                default: processCwd,
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
                description: 'provided --code is PoSh'
            },
            'is-bash': {
                type: 'boolean',
                default: false,
                description: 'provided --code is bash'
            }
        };

        return builder;
    })(process.cwd());
    exports.api = async function (request: VagrantProvisionAddRequest, response: VagrantProvisionAddResponse) {
        console.log('vagrant:provision:add ' + request["provision-name"]);
        const deepmerge = require('deepmerge');

        const path = require('path');
        const fs = require('fs-extra');
        const mkdirp = require('mkdirp');
        const _json = require('./../../../Serialization');

        const json_filepath = path.join(request.path, 'config.json');
        let json = JSON.parse(await fs.readFile(json_filepath));

        const provision: Partial<VagrantProvisioning> = {
            name: request["provision-name"],
            env: request["provision-env"],
            'os-type': request['os-type'],
            'os-version': request['os-version'],
            isPosh: request.isPosh,
            isBash: request.isBash
        }

        if (null == json['$'].provision || undefined == json['$'].provision || !Array.isArray(json['$'].provision)) {
            json['$'].provision = [];
        }

        json['$'].provision.push(provision);

        await fs.writeFile(json_filepath, _json.toJson(json));

        if (request.code && provision['os-type'] && provision['os-version']) {
            const code = (!provision.isBash ? '#!/usr/bin/env bash' : '#!/usr/bin/env pwsh') + '\r\n' + '\r\n' + request.code + '\r\n';
            const filepath = path.join(request.path, 'provision', provision['os-type'], provision['os-version']);

            if (!fs.access(filepath)) {
                await fs.mkdir(filepath, { recursive: true });
            }

            const filename = `${provision.name}.${provision.isBash ? 'sh' : 'ps1'}`;
            const fullpath = path.join(filepath, filename);
            await fs.writeFile(fullpath, code);
        }

        if (request.edit) {
            const cp = require('child_process');
            await cp.exec('code . -n');
        }
    };
    exports.handler = async function (argv: VagrantProvisionAddArgv) {
        await exports.api(argv, {});
    };
})();
