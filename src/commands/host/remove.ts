(async () => {
    const opModule = require('./../../operations/host/remove');

    exports.command = 'host:remove';
    exports.desc = 'Host Remove an Host';
    exports.builder = opModule.builder;
    exports.handler = async function (argv: HostRemoveArgv) {
        const op = opModule.handle;
        await op(argv);
    };
})();
