interface VagrantMachineSshConfigArgv{

}

(() => {
    exports.command = 'vagrant:machine:ssh-config';
    exports.desc = 'Vagrant SSH Config for Machine';
    exports.builder = ((processCwd) => {
        const builder = {

        };

        return builder;
    })(process.cwd());
    exports.handler = async function (argv: VagrantMachineSshConfigArgv) {
    };

})();
