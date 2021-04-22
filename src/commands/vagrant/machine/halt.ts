interface VagrantMachineHaltArgv extends VagrantMachineArgv {
    force: boolean
}
interface VagrantMachineHaltRequest extends VagrantMachineHaltArgv {

}

interface VagrantMachineHaltResponse extends VagrantMachineHaltArgv {

}

(() => {
    exports.command = 'vagrant:machine:halt <name>';
    exports.desc = 'Vagrant Halt a Machine';
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
            },
            force: {
                type: 'boolean',
                default: false,
                description: 'Force halt'
            }
        };

        return builder;
    })(process.cwd());
    exports.api = async function (request: VagrantMachineHaltRequest, response: VagrantMachineDestroyResponse) {
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
                'halt',
                nameResponse['machine-name'],
            ].concat(
                request.force ? ['--force'] : []
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
