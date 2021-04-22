interface VagrantMachineDestroyArgv {
    name: string
    instance: number
    path: string
    "config-env": string
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
    exports.api = async function (request: VagrantMachineDestroyRequest, response: VagrantMachineDestroyResponse) {
        const cp = require('child_process');

        const nameRequest = request;
        const nameResponse = await require('./name').api(nameRequest);

        response.name = nameResponse.name;

        const proc = await cp.spawn("vagrant", ["destroy", nameResponse.name, (request.force ? "--force" : "")], { stdio: "inherit" });
        
        return response;

    }
    exports.handler = async function (argv: VagrantMachineDestroyArgv) {
        await exports.api(argv, {});
    };

})();
