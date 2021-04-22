interface VagrantMachineStatusArgv extends VagrantMachineArgv {

}

interface VagrantMachineStatusRequest extends VagrantMachineStatusArgv {

}

interface VagrantMachineStatusResponse extends VagrantMachineStatusArgv {
    status: string
}

(async () => {
    exports.command = 'vagrant:machine:status';
    exports.desc = 'Vagrant machine status';
    exports.builder = ((processCwd) => {
        const builder = {
            name: {
                type: 'string',
            },
            instance: {
                type: 'number',
            },
            path: {
                type: 'string',
                default: processCwd
            },
            'config-env': {
                type: 'string',
                default: 'dev'
            }
        };

        return builder;
    })(process.cwd());
    exports.api = async function (request: VagrantMachineStatusRequest, response: VagrantMachineStatusResponse) {
        const cp = require('child_process');

        const nameRequest = request;
        const nameResponse: VagrantMachineNameResponse = await require('./name').api(nameRequest);

        response['machine-name'] = nameResponse['machine-name'];

        const proc = await cp.spawn(
            'vagrant',
            [
                'status',
                nameResponse['machine-name']
            ],
            {
                stdio: 'inherit',
                cwd: request.path
            }
        );

        return response;
    };
    exports.handler = async function (argv: VagrantMachineStatusArgv) {
        await exports.api(argv, {});
    };
})();
