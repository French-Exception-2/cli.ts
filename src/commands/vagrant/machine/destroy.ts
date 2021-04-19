interface VagrantMachineDestroyArgv {
    name: string
    instance: number
    path: string
    force: boolean
}

(() => {
    exports.command = 'vagrant:machine:destroy';
    exports.desc = 'Vagrant Destroy a Machine';
    exports.builder = ((process) => {
        const builder = {

        };

        return builder;
    })(process);
    exports.handler = async function (argv: VagrantMachineDestroyArgv) {
        const path = require('path');
        const fs = require('fs-extra');
        const _json = require('./../../../Serialization');
        const deepmerge = require('deepmerge');
        const sprintf = require('sprintf-js').sprintf;
        const cp = require('child_process');

        const json_filepath = path.join(argv.path, 'config.json');
        let json = JSON.parse(await fs.readFile(json_filepath));

        const json_local_filepath = path.join(argv.path, 'config-local.json');
        let json_local = JSON.parse(await fs.readFile(json_local_filepath));

        const merged = deepmerge(json, json_local);

        const vagrant_instance_str = sprintf('%02d', merged.vagrant.instance);
        const vagrant_machine_instance_str = sprintf('%02d', argv.instance);
        const vagrant_machine_str = merged.nodes[argv.name].hostname_pattern
            .replace(/\#\{VAGRANT_INSTANCE\}/, vagrant_instance_str)
            .replace(/\#\{NAME\}/, argv.name)
            .replace(/\#\{INSTANCE\}/, vagrant_machine_instance_str)

        await cp.spawn("vagrant", ["destroy", vagrant_machine_str, (argv.force ? "--force" : "")], { stdio: "inherit" });
    };

})();
