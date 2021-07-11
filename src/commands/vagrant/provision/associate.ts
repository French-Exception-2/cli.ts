interface VagrantProvisionAssociateArgv extends VagrantMachineArgv {
    'machine-type-name': string
    'provision-name': string
    env: Array<string>
    path: string
}

interface VagrantProvisionAssociateRequest extends VagrantProvisionAssociateArgv {

}

interface VagrantProvisionAssociateResponse extends VagrantProvisionAssociateArgv {

}

(async () => {
    exports.command = 'vagrant:provision:associate';
    exports.desc = 'Associate Vagrant Provision & Machine Type';
    exports.builder = ((processCwd) => {
        const builder = {
            'machine-type-name': {
                type: 'string',
                describe: 'Machine type name to associate with provision'
            },
            'machine-name': {
                type: 'string',
                describe: 'Machine name to associate with provision'
            },
            'machine-instance': {
                type: 'string',
                describe: 'Machine instance to associate with provision'
            },
            'provision-name': {
                type: 'string',
                describe: 'Provision name to associate'
            },
            env: {
                type: 'array',
                description: 'ENV Vars as KEY=VALUE',
                default: []
            },
            path: {
                type: 'string',
                default: process.cwd(),
            },
            'config-env': {
                type: 'string',
                default: 'dev'
            },
        };

        return builder;
    })(process.cwd());
    exports.api = async function (request: VagrantProvisionAssociateRequest, response: VagrantProvisionAssociateResponse) {
        console.log(`vagrant:provision:associate ${request['machine-type-name']} ${request['provision-name']}`);

        const path = require('path');
        const fs = require('fs-extra');
        const mkdirp = require('mkdirp');
        const _json = require('./../../../Serialization');

        const json_filepath = path.join(request.path, 'config.json');
        let json = JSON.parse(await fs.readFile(json_filepath));

        let target;
        let type;
        if (request['machine-type-name']) {
            target = json['$']['machines-types'][request['machine-type-name']]
        } else {
            target = json['$']['machines'][request['machine-name']]
            type = json['$']['machines-types'][target['machine-type-name']];
        }

        if (Array.isArray(target.provision) || null == target.provision || undefined == target.provision) {
            target.provision = {};
        }

        target.provision[request['provision-name']] = {
            env: request.env,
            extension: type && type['os-type'] == 'Debian_64' ? 'sh' : 'ps1'
        }

        await fs.writeFile(json_filepath, _json.toJson(json));
    };
    exports.handler = async function (argv: VagrantProvisionAssociateArgv) {
        await exports.api(argv, {});
    };
})();
