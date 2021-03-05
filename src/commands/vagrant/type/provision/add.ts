
exports.command = 'vagrant:type:provision:add'
exports.desc = 'Add new Vagrant Machine Type Provisioning'
exports.builder = {
    name: {
        type: "string",
        required: true,
        description: "Name of Type",
    },
    path: {
        type: "string",
        default: process.cwd(),
    },
    enabled: {
        type: "boolean",
        default: true,
    },
    type: {
        type: 'string',
        required: true,
    },
    env: {
        type: 'array',
        default: [],
    },
    extension: {
        type: 'string',
        default: 'sh'
    }
}
exports.handler = async function (argv: VagrantNodeTypeProvisionAddArgv) {
    const path = require('path');
    const fs = require('fs-extra');
    const _json = require('./../../../../operations/Serialization');

    const json_filepath = path.join(argv.path, 'config.json');
    let json = JSON.parse(await fs.readFile(json_filepath));

    const provisioning: Partial<VagrantProvisioning> = {
        enabled: argv.enabled,
        extension: argv.extension,
    }

    if (argv.env) {
        (<any>provisioning.env) = {}

        argv.env.forEach((v) => {
            const a = v.split('=');
            (<any>provisioning.env)[a[0]] = a[1];
        });
    }

    if (!json["nodes-types"][argv.type].provisioning) {
        json["nodes-types"][argv.type].provisioning = {};
    }

    json["nodes-types"][argv.type].provisioning[argv.name] = provisioning;

    const data = _json.toJson(json);
    await fs.writeFile(json_filepath, data);
}
