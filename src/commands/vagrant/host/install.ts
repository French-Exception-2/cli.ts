(async () => {
    const opModule = require("./../../../operations/vagrant/host/install");

    exports.command = 'vagrant:host:install';
    exports.desc = 'Vagrant Host install';
    exports.builder = opModule.builder;
    exports.handler = async function (argv: VagrantHostInstallArgv) {
        const op = opModule.handle;
        await op(argv);
    };
})();
