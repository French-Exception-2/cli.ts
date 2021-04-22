interface VagrantMachineUpArgv extends VagrantMachineArgv {

}

interface VagrantMachineUpRequest extends VagrantMachineUpArgv {

}

interface VagrantMachineUpResponse extends VagrantMachineUpArgv {

}

(() => {
    exports.command = 'vagrant:machine:up <machine-name>';
    exports.desc = 'Vagrant Up a Machine';
    exports.builder = ((processCwd: string) => {
        const builder = {
            'machine-name': {
                type: 'string',
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
            },
        };

        return builder;
    })(process.cwd());
    exports.api = async function (request: VagrantMachineSshRequest, response: VagrantMachineSshResponse) {
        const cp = require('child_process');

        const nameRequest: VagrantMachineNameRequest = {
            'config-env': request['config-env'],
            'machine-instance': request['machine-instance'],
            'machine-name': request['machine-name'],
            'path': request.path
        };

        const nameResponse: VagrantMachineNameResponse = await require('./name').api(nameRequest);

        response['machine-name'] = nameResponse['machine-name'];

        const proc = await cp.spawn(
            'vagrant',
            [
                'up',
                nameResponse['machine-name']
            ],
            {
                stdio: 'inherit',
                cwd: request.path
            }
        );

        return response;

    }
    exports.handler = async function (argv: VagrantMachineDestroyArgv) {
        await exports.api(argv, {});
    };
})();
