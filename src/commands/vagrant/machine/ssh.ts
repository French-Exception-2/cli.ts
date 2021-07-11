interface VagrantMachineSshArgv extends VagrantMachineArgv {
    command?: string
    plain?: boolean
    tty: boolean
    color: boolean
    'machine-readable': boolean
}
interface VagrantMachineSshRequest extends VagrantMachineSshArgv {

}

interface VagrantMachineSshResponse extends VagrantMachineSshArgv {

}

(() => {
    exports.command = 'vagrant:machine:ssh <machine-name>';
    exports.desc = 'Vagrant SSH a Machine';
    exports.builder = ((processCwd: string) => {
        const builder = {
            'machine-name': {
                type: 'string',
                required: true
            },
            instance: {
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
            'command': {
                type: 'string',
                default: null
            },
            'plain': {
                type: 'boolean',
                default: false
            },
            'tty': {
                type: 'boolean',
                default: true
            },
            'color': {
                type: 'boolean',
                default: true
            },
            'machine-readable': {
                type: 'boolean',
                default: false
            }
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
                'ssh',
                nameResponse['machine-name']
            ].concat(
                request.command ? ['--command', request.command] : []
            ).concat(
                request.plain ? ['--plain'] : []
            ).concat(
                request.tty ? ['--tty'] : []
            ).concat(
                request.color ? ['--color'] : []
            ).concat(
                request['machine-name'] ? ['--machine-readable'] : []
            ),
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
