(async () => {
    const opModule = require('./../../operations/host/get');

    exports.command = 'host:get';
    exports.desc = 'Host Get Host';
    exports.builder = opModule.builder;
    exports.handler = async function (argv: HostGetArgv) {
        const op = opModule.handle;
        await op(argv);
    };
})();
