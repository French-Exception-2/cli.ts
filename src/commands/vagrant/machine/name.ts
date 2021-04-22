interface VagrantMachineNameArgv {
    name: string
    instance: number
    path: string
    "config-env": string
}

(() => {
    exports.command = 'vagrant:machine:name <name>';
    exports.desc = 'Vagrant name machine';
    exports.builder = ((processCwd : string) => {
        const builder = {
            name: {
                type: "string",
                required: true
            },
            instance: {
                type: "number",
                default: 0,
            },
            path: {
                type: "string",
                default: processCwd,
            },
            "config-env": {
                type: 'string',
                default: 'dev'
            }
        };

        return builder;
    })(process.cwd());
    exports.handler = async function (argv: VagrantMachineNameArgv) {
        const path = require('path');
        const fs = require('fs-extra');
        const _json = require('./../../../Serialization');
        const deepmerge = require('deepmerge');
        const sprintf = require('sprintf-js').sprintf;
        const cp = require('child_process');

        const config = await require('@frenchex/config-api').fromFile({
            env: { env: argv["config-env"] },
            file: path.join(argv.path, 'config.json'),
            root: argv.path
        });

        const hostnamePattern = await config.get('nodes.' + argv.name + '.hostname-pattern', null);
        
        if (typeof hostnamePattern != 'string') {
            throw new Error('Machine ' + argv.name + ' cannot be found');
        }

        const vagrant_machine_instance_str = sprintf('%02d', argv.instance);
        const vagrant_machine_str = hostnamePattern
            .replace(/\#\{NAME\}/, argv.name)
            .replace(/\#\{INSTANCE\}/, vagrant_machine_instance_str);

        console.log(vagrant_machine_str);
    };

})();