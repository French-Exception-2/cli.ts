interface VagrantProvisionAssociateArgv {
    "machine-type-name": string
    "machine-name": string
    "provision-name": string
    env: Array<string>
    path: string
}

(async () => {
    exports.command = 'vagrant:provision:associate';
    exports.desc = 'Associate Vagrant Provision & Machine Type';
    exports.builder = ((processCwd) => {
        const builder = {
            "machine-type-name": {
                type: "string",
                describe: 'Machine type name to associate with provision'
            },
            "machine-name": {
                type: "string",
                describe: 'Machine name to associate with provision'
            },
            "provision-name": {
                type: "string",
                describe: 'Provision name to associate'
            },
            env: {
                type: "array",
                description: "ENV Vars as KEY=VALUE",
                default: []
            },
            path: {
                type: "string",
                default: process.cwd(),
            }
        };

        return builder;
    })(process.cwd());
    exports.handler = async function (argv: VagrantProvisionAssociateArgv) {
        console.log(`vagrant:provision:associate ${argv['machine-type-name']} ${argv["provision-name"]}`);

        const path = require('path');
        const fs = require('fs-extra');
        const mkdirp = require('mkdirp');
        const _json = require('./../../../Serialization');

        const json_filepath = path.join(argv.path, 'config.json');
        let json = JSON.parse(await fs.readFile(json_filepath));

        let target;
        let type;
        if (argv["machine-type-name"]) {
            target = json['$']['nodes-types'][argv["machine-type-name"]]
        } else {
            target = json['$']['nodes'][argv["machine-name"]]
            type = json['$']['nodes-types'][target['vagrant_type']];
        }

        if (Array.isArray(target.provision) || null == target.provision || undefined == target.provision) {
            target.provision = {};
        }

        target.provision[argv["provision-name"]] = {
            env: argv.env,
            extension: type && type['os-type'] == "Debian_64" ? 'sh' : 'ps1'
        }

        await fs.writeFile(json_filepath, _json.toJson(json));
    };
})();
