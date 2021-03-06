(async () => {
    const opModule = require('./../../operations/config/dump');

    exports.command = 'config:dump';
    exports.desc = 'Dump configuration';
    exports.builder = opModule.builder;
    exports.handler = async function (argv: ConfigDumpArgv) {
        const op = opModule.handle;
        await op(argv);
    };
})();
