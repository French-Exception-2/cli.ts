interface VagrantMachineTypeListArgv {
  path: string
}

interface VagrantMachineTypeListRequest extends VagrantMachineTypeListArgv {

}

interface VagrantMachineTypeListResponse extends VagrantMachineTypeListArgv {

}

(() => {
  exports.command = 'vagrant:machine-type:list';
  exports.desc = 'List Vagrant Machine Types';
  exports.builder = ((processCwd) => {
    const builder = {
      path: {
        type: 'string',
        default: processCwd
      },
    };

    return builder;
  })(process.cwd());
  exports.api = async function (request: VagrantMachineTypeAddRequest, response: VagrantMachineTypeAddResponse) {
    return response;
  };
  exports.handler = async function (argv: VagrantMachineTypeAddArgv) {
    await exports.api(argv, {});
  };
})();