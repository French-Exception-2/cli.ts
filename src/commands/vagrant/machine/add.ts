interface VagrantMachineAddArgv {
    'machine-name': string
    'machine-type-name': string
    'hostname-pattern': string
    instances: number
    enabled: boolean
    primary: boolean
    'ip-pattern': string
    'ip-start': number
    'ram-mb': number
    vcpus: number
    path: string
}

interface VagrantMachineAddRequest extends VagrantMachineAddArgv {

}

interface VagrantMachineAddResponse extends VagrantMachineAddArgv {

}

(() => {
    exports.command = 'vagrant:machine:add <machine-name> <machine-type-name>';
    exports.desc = 'Vagrant add a new Machine';
    exports.builder = ((processCwd) => {
        const builder = {
            'machine-name': {
                type: 'string',
                required: true,
                description: 'Machine name'
            },
            'config-env': {
                type: 'string',
                default: 'dev'
            },
            'machine-type-name': {
                type: 'string',
                description: 'Name of VM'
            },
            'hostname-pattern': {
                type: 'string',
                default: 'vdi-%vagrant.instance.formatted%-#{NAME}-#{INSTANCE}',
            },
            instances: {
                type: 'number',
                required: true,
                description: '# Instances',
                default: 1
            },
            enabled: {
                type: 'boolean',
                default: true
            },
            primary: {
                type: 'boolean',
                default: true
            },
            'ip-pattern': {
                type: 'string',
                default: '10.100.2.#{INSTANCE}'
            },
            'ip-start': {
                type: 'number',
                default: 10
            },
            'ram-mb': {
                type: 'number',
                default: 2096
            },
            vcpus: {
                type: 'number',
                default: 2
            },
            path: {
                type: 'string',
                default: processCwd,
            }
        };

        return builder;
    })(process.cwd());
    exports.api = async function (request: VagrantMachineAddRequest, response: VagrantMachineAddResponse) {
        console.log('vagrant:machine:add ' + request['machine-name']);
        const path = require('path');
        const fs = require('fs-extra');
        const _json = require('./../../../Serialization');

        //@todo use @frenchex/config-api .fromFile() and .save()
        const json_filepath = path.join(request.path, 'config.json');
        let json = JSON.parse(await fs.readFile(json_filepath));

        if (!json['$'].machines || Array.isArray(json['$'].machines)) {
            json['$'].machines = {};
        }

        json['$'].machines[request['machine-name']] = {
            'machine-type-name': request['machine-type-name'],
            'hostname-pattern': request['hostname-pattern'],
            instances: request.instances,
            enabled: request.enabled,
            primary: request.primary,
            vcpus: request.vcpus,
            'ip-pattern': request['ip-pattern'],
            'ip-start': request['ip-start']
        }

        const data = _json.toJson(json);
        await fs.writeFile(json_filepath, data);

        return response;
    };
    exports.handler = async function (argv: VagrantMachineAddArgv) {
        await exports.api(argv, {});
    };
})();