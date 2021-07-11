interface VagrantMachineSshConfigArgv extends VagrantMachineArgv {
}
interface VagrantMachineSshConfigRequest extends VagrantMachineSshConfigArgv {

}

interface VagrantMachineSshConfigResponse extends VagrantMachineSshConfigArgv {

}

(() => {
    exports.command = 'vagrant:machine:ssh-config <name>';
    exports.desc = 'Vagrant SSH-Config a Machine';
    exports.builder = ((processCwd: string) => {
        const builder = {
            'provision-name': {
                type: 'string',
                required: true
            },
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
            }
        };

        return builder;
    })(process.cwd());
    exports.api = async function (request: VagrantMachineSshConfigRequest, response: VagrantMachineSshConfigResponse) {
        const cp = require('child_process');

        const nameRequest: VagrantMachineNameRequest = {
            'config-env': request['config-env'],
            'machine-instance': request['machine-instance'],
            'machine-name': request['machine-name'],
            'path': request.path
        };

        const nameResponse = await require('./name').api(nameRequest);

        response['machine-name'] = nameResponse.name;

        const proc = await cp.spawn(
            'vagrant',
            [
                'ssh-config',
                nameResponse.name
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
