(async () => {
    const opModule = require('./../../operations/host/list');

    exports.command = 'host:list';
    exports.desc = 'Host List Hosts';
    exports.builder = opModule.builder;
    exports.handler = async function (argv: HostListArgv) {
        const op = opModule.handle;
        await op(argv);
    };
})();
