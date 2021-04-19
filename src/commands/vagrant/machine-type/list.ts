interface VagrantMachineTypeListArgv {

}

(async () => {
  exports.command = 'vagrant:machine-type:list';
  exports.desc = 'Vagrant list types of machines';
  exports.builder = ((processCwd) => {
    const builder = {

    };

    return builder;
  })(process.cwd());
  exports.handler = async function (argv: VagrantMachineTypeListArgv) {
  };
})();
