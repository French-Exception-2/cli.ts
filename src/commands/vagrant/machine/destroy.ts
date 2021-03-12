(() => {

    const opModule = require('./../../../operations/vagrant/machine/destroy');

    exports.command = 'vagrant:machine:destroy';
    exports.desc = 'Vagrant Destroy a Machine';
    exports.builder = opModule.builder;
    exports.handler = async function (argv: VagrantMachineDestroyArgv) {
        const op = opModule.handle;
        await op(argv);
    };

})();