(async () => {
    const opModule = require('./../../operations/host/add');

    exports.command = 'host:add';
    exports.desc = 'Host Add a new Host';
    exports.builder = opModule.builder;
    exports.handler = async function (argv: HostAddArgv) {
        const op = opModule.handle;
        await op(argv);
    };
})();
