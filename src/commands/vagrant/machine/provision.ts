interface VagrantMachineProvisionArgv{
    
}

(async () => {
    exports.command = 'vagrant:machine:provision';
    exports.desc = 'Vagrant provision machine';
    exports.builder = ((process) => {

    })(process);
    exports.handler = async function (argv: VagrantMachineProvisionArgv) {
        throw new Error("not yet implemented");
    };
  })();
