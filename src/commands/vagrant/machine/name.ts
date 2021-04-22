interface VagrantMachineNameArgv extends VagrantMachineArgv {

}

interface VagrantMachineNameRequest extends VagrantMachineNameArgv {

}

interface VagrantMachineNameResponse extends VagrantMachineNameArgv {

}

(() => {
    exports.command = 'vagrant:machine:name <machine-name>';
    exports.desc = 'Vagrant name machine';
    exports.builder = ((processCwd: string) => {
        const builder = {
            'machine-name': {
                type: 'string',
                required: true
            },
            'machine-instance': {
                type: 'number',
                default: 0,
            },
            path: {
                type: 'string',
                default: processCwd,
            },
            'config-env': {
                type: 'string',
                default: 'dev'
            }
        };

        return builder;
    })(process.cwd());
    exports.api = async function (request: VagrantMachineNameRequest, response: VagrantMachineNameResponse) {
        response = response || request;

        const path = require('path');
        const sprintf = require('sprintf-js').sprintf;

        const config = await require('@frenchex/config-api').fromFile({
            env: { env: request['config-env'] },
            file: path.join(request.path, 'config.json'),
            root: request.path
        });

        const hostnamePattern = await config.get('machines.' + request['machine-name'] + '.hostname-pattern', null);

        if (typeof hostnamePattern != 'string') {
            throw new Error('Machine ' + request['machine-name'] + ' cannot be found');
        }

        const vagrant_machine_instance_str = sprintf('%02d', request['machine-instance']);
        const vagrant_machine_str = hostnamePattern
            .replace(/\#\{NAME\}/, request['machine-name'])
            .replace(/\#\{INSTANCE\}/, vagrant_machine_instance_str);

        response['machine-name'] = vagrant_machine_str;

        return response;
    };
    exports.handler = async function (argv: VagrantMachineNameArgv) {
        const response = await exports.api(argv);
        console.log(response.name);
    };
})();