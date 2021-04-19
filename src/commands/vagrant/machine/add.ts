interface VagrantMachineProvisionAddArgv extends VagrantMachineArgv {
    "type-name": string
    "hostname-pattern": string
    instances: number
    enabled: boolean
    primary: boolean
    "ip-pattern": string
    "ip-start": number
    "ram-mb": number
    vcpus: number
    path: string
}

(() => {
    exports.command = 'vagrant:machine:add';
    exports.desc = 'Vagrant add a new Machine';
    exports.builder = ((processCwd) => {
        const builder = {
            type_name: {
                type: "string",
                description: "Name of VM"
            },
            hostname_pattern: {
                type: "string",
                default: "vdi-%vagrant.instance.formatted%-#{NAME}-#{INSTANCE}",
            },
            instances: {
                type: "number",
                required: true,
                description: "# Instances",
                default: 1
            },
            enabled: {
                type: "boolean",
                default: true
            },
            primary: {
                type: "boolean",
                default: true
            },
            ip_pattern: {
                type: "string",
                default: "10.100.2.#{INSTANCE}"
            },
            ip_start: {
                type: "number",
                default: 10
            },
            ram_mb: {
                type: "number",
                default: 2096
            },
            vcpus: {
                type: "number",
                default: 2
            },
            path: {
                type: "string",
                default: processCwd,
            }
        };

        return builder;
    })(process.cwd());
    exports.handler = async function (argv: VagrantMachineProvisionAddArgv) {
        console.log('vagrant:machine:add.begin');
        const path = require('path');
        const fs = require('fs-extra');
        const _json = require('./../../../Serialization');

        const json_filepath = path.join(argv.path, 'config.json');
        let json = JSON.parse(await fs.readFile(json_filepath));

        json.nodes[argv.name] = {
            vagrant_type: argv["type-name"],
            hostname_pattern: argv["hostname-pattern"],
            instances: argv.instances,
            enabled: argv.enabled,
            primary: argv.primary,
            vcpus: argv.vcpus,
            ip_pattern: argv["ip-pattern"],
            ip_start: argv["ip-start"]
        }

        const data = _json.toJson(json);
        await fs.writeFile(json_filepath, data);

        console.log('vagrant:machine:add.end');
    };

})();