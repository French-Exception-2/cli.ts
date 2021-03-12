(async () => {
    const opModule = require("./../../../operations/vagrant/host/list");

    exports.command = 'vagrant:host:list';
    exports.desc = 'Vagrant Host list';
    exports.builder = opModule.builder;
    exports.handler = async function (argv: VagrantHostListArgv) {
        const op = opModule.handle;
        await op(argv);
    };
})();
