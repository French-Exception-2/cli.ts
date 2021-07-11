interface VagrantMachineDestroyArgv extends VagrantMachineArgv {
    force: boolean
}
interface VagrantMachineDestroyRequest extends VagrantMachineDestroyArgv {

}

interface VagrantMachineDestroyResponse extends VagrantMachineDestroyArgv {

}

(() => {
    exports.command = 'vagrant:machine:destroy <name>';
    exports.desc = 'Vagrant Destroy a Machine';
    exports.builder = ((processCwd: string) => {
        const builder = {
            name: {
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
            }
        };

        return builder;
    })(process.cwd());
    exports.api = async function (request: VagrantMachineDestroyRequest, response: VagrantMachineDestroyResponse) {
        const cp = require('child_process');

        const nameRequest: VagrantMachineNameRequest = {
            'config-env': request['config-env'],
            'machine-name': request['machine-name'],
            'machine-instance': request['machine-instance'],
            path: request.path
        };

        const nameResponse: VagrantMachineNameResponse = await require('./name').api(nameRequest);

        response['machine-name'] = nameResponse['machine-name'];

        const proc = await cp.spawn(
            'vagrant',
            [
                'destroy',
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
