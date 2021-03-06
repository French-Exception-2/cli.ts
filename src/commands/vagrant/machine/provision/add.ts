(async () => {
    const opModule = require('./../../../../operations/vagrant/machine/provision/add');

    exports.command = 'vagrant:machine:provision:add';
    exports.desc = 'Add new Vagrant Machine Provisioning';
    exports.builder = opModule.builder;
    exports.handler = async function (argv: VagrantMachineProvisionAddArgv) {
        const op = opModule.handle;
        await op(argv);
    };
})();
