interface VagrantMachineNameArgv {
    name: string
    instance: number
    path: string
    "config-env": string
}

interface VagrantMachineNameRequest extends VagrantMachineNameArgv {

}

interface VagrantMachineNameResponse extends VagrantMachineNameArgv {

}

(() => {
    exports.command = 'vagrant:machine:name <name>';
    exports.desc = 'Vagrant name machine';
    exports.builder = ((processCwd: string) => {
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
    exports.api = async function (request: VagrantMachineNameRequest, response: VagrantMachineNameResponse) {
        response = response || {};

        const path = require('path');
        const fs = require('fs-extra');
        const _json = require('./../../../Serialization');
        const deepmerge = require('deepmerge');
        const sprintf = require('sprintf-js').sprintf;
        const cp = require('child_process');

        const config = await require('@frenchex/config-api').fromFile({
            env: { env: request["config-env"] },
            file: path.join(request.path, 'config.json'),
            root: request.path
        });

        const hostnamePattern = await config.get('nodes.' + request.name + '.hostname-pattern', null);

        if (typeof hostnamePattern != 'string') {
            throw new Error('Machine ' + request.name + ' cannot be found');
        }

        const vagrant_machine_instance_str = sprintf('%02d', request.instance);
        const vagrant_machine_str = hostnamePattern
            .replace(/\#\{NAME\}/, request.name)
            .replace(/\#\{INSTANCE\}/, vagrant_machine_instance_str);

        response.name = vagrant_machine_str;

        return response;
    };
    exports.handler = async function (argv: VagrantMachineNameArgv) {
        const response = await exports.api(argv);
        console.log(response.name);
    };

})();