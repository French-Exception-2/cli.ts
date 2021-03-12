(async () => {
    const opModule = require("./../../../operations/vagrant/host/remove");

    exports.command = 'vagrant:host:remove';
    exports.desc = 'Vagrant Host remove';
    exports.builder = opModule.builder;
    exports.handler = async function (argv: VagrantHostRemoveArgv) {
        const op = opModule.handle;
        await op(argv); 
    };
})();
