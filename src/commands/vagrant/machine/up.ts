interface VagrantMachineUpArgv {

}

(async () => {
    exports.command = 'vagrant:machine:up';
    exports.desc = 'Vagrant up machine';
    exports.builder = ((processCwd) => {
        const builder = {

        };

        return builder;
    })(process.cwd());
    exports.handler = async function (argv: VagrantMachineUpArgv) {
    };
  })();
