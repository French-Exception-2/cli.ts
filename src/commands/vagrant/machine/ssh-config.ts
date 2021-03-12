(() => {

    const opModule = require('./../../../operations/vagrant/machine/ssh-config');

    exports.command = 'vagrant:machine:ssh-config';
    exports.desc = 'Vagrant SSH Config for Machine';
    exports.builder = opModule.builder;
    exports.handler = async function (argv: VagrantMachineSshConfigArgv) {
        const op = opModule.handle;
        await op(argv);
    };

})();
