(() => {

    const opModule = require('./../../../operations/vagrant/machine/name');

    exports.command = 'vagrant:machine:name';
    exports.desc = 'Vagrant name machine';
    exports.builder = opModule.builder;
    exports.handler = async function (argv: VagrantMachineNameArgv) {
        const op = opModule.handle;
        await op(argv);
    };

})();