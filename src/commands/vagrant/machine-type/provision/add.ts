(async () => {
    const opModule = require('./../../../../operations/vagrant/machine-type/provision/add');

    exports.command = 'vagrant:machine-type:provision:add';
    exports.desc = 'Add new Vagrant Type Provisioning';
    exports.builder = opModule.builder;
    exports.handler = async function (argv: VagrantMachineTypeProvisionAddArgv) {
        const op = opModule.handle;
        await op(argv);
    };
})();
