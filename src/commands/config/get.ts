(async () => {
    const opModule = require('./../../operations/config/get');

    exports.command = 'config:get';
    exports.desc = 'Get value from configuration';
    exports.builder = opModule.builder;
    exports.handler = async function (argv: ConfigGetArgv) {
        const op = opModule.handle;
        await op(argv);
    };
})();
