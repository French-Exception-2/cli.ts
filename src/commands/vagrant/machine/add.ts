interface VagrantMachineProvisionAddArgv extends VagrantMachineArgv {
    "machine-type-name": string
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
            "machine-type-name": {
                type: "string",
                description: "Name of VM"
            },
            "hostname-pattern": {
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
            "ip-pattern": {
                type: "string",
                default: "10.100.2.#{INSTANCE}"
            },
            "ip-start": {
                type: "number",
                default: 10
            },
            "ram-mb": {
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
        console.log('vagrant:machine:add ' + argv.name);
        const path = require('path');
        const fs = require('fs-extra');
        const _json = require('./../../../Serialization');

        const json_filepath = path.join(argv.path, 'config.json');
        let json = JSON.parse(await fs.readFile(json_filepath));

        if (!json['$'].nodes || Array.isArray(json['$'].nodes)) {
            json['$'].nodes = {};
        }

        json['$'].nodes[argv.name] = {
            "vagrant-type": argv["machine-type-name"],
            "hostname-pattern": argv["hostname-pattern"],
            instances: argv.instances,
            enabled: argv.enabled,
            primary: argv.primary,
            vcpus: argv.vcpus,
            "ip-pattern": argv["ip-pattern"],
            "ip-start": argv["ip-start"]
        }

        const data = _json.toJson(json);
        await fs.writeFile(json_filepath, data);

    };

})();