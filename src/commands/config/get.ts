(async () => {
    const opModule = require('./../../operations/config/get');

    exports.command = 'config:get';
    exports.desc = 'Get configuration';
    exports.builder = opModule.builder;
    exports.group = "Config"
    exports.handler = async function (argv: ConfigGetArgv) {
        const op = opModule.handle;
        await op(argv);
    };
})();
