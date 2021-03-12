(async () => {
    const opModule = require("./../../../operations/vagrant/host/add");

    exports.command = 'vagrant:host:add';
    exports.desc = 'Vagrant Host add';
    exports.builder = opModule.builder;
    exports.handler = async function (argv: VagrantHostAddArgv) {
        const op = opModule.handle;
        await op(argv);
    };
})();
