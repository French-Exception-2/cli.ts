exports.builder = {
    type_name: {
        type: "string",
        description: "Name of VM"
    },
    hostname_pattern: {
        type: "string",
        default: "vdi-#{VAGRANT_INSTANCE}-#{NAME}-#{INSTANCE}",
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
        default: process.cwd(),
    }
}

exports.handle = async function(argv:VagrantMachineAddArgv) {
    const path = require('path');
    const fs = require('fs-extra');
    const _json = require('./../../../operations/Serialization');

    const json_filepath = path.join(argv.path, 'config.json');
    let json = JSON.parse(await fs.readFile(json_filepath));

    json.nodes[argv.name] = {
        vagrant_type: argv.type,
        hostname_pattern: argv.hostname_pattern,
        instances: argv.instances,
        enabled: argv.enabled,
        primary: argv.primary,
        vcpus: argv.vcpus,
        ip_pattern: argv.ip_pattern,
        ip_start: argv.ip_start
    }

    const data = _json.toJson(json);
    await fs.writeFile(json_filepath, data);
}