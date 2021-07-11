export interface VagrantMachineAddArgv {
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

export interface VagrantMachineAddRequest extends VagrantMachineAddArgv {

}

export interface VagrantMachineAddResponse extends VagrantMachineAddArgv {

}

export const command: string = 'vagrant:machine:add <machine-name> <machine-type-name>';
export const desc: string = ''

export const defaults = async function (argv: Partial<VagrantMachineAddArgv>): Promise<VagrantMachineAddArgv> {
    const defaults = {
        'machine-name': argv['machine-name'] ?? 'dev',
        'ram-mb': argv['ram-mb'] ?? 512,
        'vcpus': argv.vcpus ?? 1,
        'machine-type-name': argv['machine-type-name'] ?? 'dev',
        'hostname-pattern': argv['hostname-pattern'] ?? '',
        instances: argv.instances ?? 1,
        enabled: argv.enabled ?? false,
        primary: argv.primary ?? false,
        'ip-pattern': argv['ip-pattern'] ?? '10.100.1.#{INSTANCE}',
        'ip-start': argv['ip-start'] ?? 10,
        path: argv.path ?? '/tmp'
    };

    return defaults;
};

export const builder = ((processCwd) => {
    const defaults: VagrantMachineAddArgv = exports.defaults();

    const builder = {
        'machine-name': {
            type: 'string',
            required: true,
            description: 'Machine name',
            default: defaults['machine-name']
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

export const api = async function (request: VagrantMachineAddRequest, response: VagrantMachineAddResponse) {
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

export const handler = async function (argv: VagrantMachineAddArgv) {
    await exports.api(argv, {});
};