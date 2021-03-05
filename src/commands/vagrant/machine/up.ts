exports.command = 'vagrant:machine:up'
exports.desc = 'Up a new machine in current workspace'
exports.builder = {
    name: {
        type: "array",
        required: true,
        description: "Names of machines to Up",
    },
    instances: {
        type: "array",
        required: true,
        default: [0]
    },
    provision: {
        type: "boolean",
        default: false,
        description: "Run provisioning on up"
    },
    path: {
        type: "string",
        default: process.cwd()
    }
}
exports.handler = async function (argv: VagrantMachineUpArgs) {
    const path = require('path');
    const fs = require('fs-extra');
    const _json = require('./../../../operations/Serialization');
    const deepmerge = require('deepmerge');
    const cp = require('child_process');
    const sprintf = require('sprintf-js').sprintf;

    const json_filepath = path.join(argv.path, 'config.json');
    const local_json_filepath = path.join(argv.path, 'config-local.json')
    var localConfig = JSON.parse(await fs.readFile(local_json_filepath));
    let json = JSON.parse(await fs.readFile(json_filepath));

    json = deepmerge(json, localConfig);

    const machines: Array<string> = [];

    argv.name.forEach(async (name: string) => {

        const config_machine = json['nodes'][name];

        argv.instances.forEach(async (instance: number) => {

            let machine_instance_name_pattern = config_machine['hostname_pattern'];
            machine_instance_name_pattern = machine_instance_name_pattern.replace('#{VAGRANT_INSTANCE}', sprintf("%02d", json.vagrant.instance));
            machine_instance_name_pattern = machine_instance_name_pattern.replace('#{NAME}', name);
            machine_instance_name_pattern = machine_instance_name_pattern.replace('#{INSTANCE}', sprintf("%02d", instance));

            machines.push(machine_instance_name_pattern);

        });
    });

    machines.forEach(async (name: string) => {
        console.log(name);
        await cp.spawn("vagrant", ["up", name], {
            stdio: "inherit"
        });
    });

}
