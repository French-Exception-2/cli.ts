interface VagrantMachineProvisionArgv extends VagrantMachineArgv {
    'provision-name': string
}
interface VagrantMachineProvisionRequest extends VagrantMachineProvisionArgv {

}

interface VagrantMachineProvisionResponse extends VagrantMachineProvisionArgv {

}

(() => {
    exports.command = 'vagrant:machine:provision <machine-name>';
    exports.desc = 'Vagrant Provision a Machine';
    exports.builder = ((processCwd: string) => {
        const builder = {
            'provision-name': {
                type: 'string',
                required: false,
                default: null
            },
            'machine-name': {
                type: 'string',
                required: true,
                description: 'Machine name to provision'
            },
            'machine-instance': {
                type: 'number',
                default: 0,
                description: 'Machine instance to provision'
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
    exports.api = async function (request: VagrantMachineProvisionRequest, response: VagrantMachineProvisionResponse) {
        const cp = require('child_process');

        const nameRequest: VagrantMachineNameRequest = {
            'config-env': request['config-env'],
            'machine-instance': request['machine-instance'],
            'machine-name': request['machine-name'],
            'path': request.path
        };

        const nameResponse: VagrantMachineNameResponse = await require('./name').api(nameRequest);

        response['machine-name'] = nameResponse["machine-name"];

        const proc = await cp.spawn('vagrant',
            [
                'provision',
                nameResponse['machine-name']
            ].concat(
                request['provision-name'] ? ['--provision-with', request['provision-name']] : []
            ),
            { stdio: 'inherit' }
        );

        return response;
    }
    exports.handler = async function (argv: VagrantMachineProvisionArgv) {
        await exports.api(argv, {});
    };

})();
