(async () => {
    const opModule = require('./../../operations/config/set');

    exports.command = 'config:set';
    exports.desc = 'Set configuration';
    exports.builder = opModule.builder;
    exports.group = "Config"
    exports.handler = async function (argv: ConfigSetArgv) {
        const op = opModule.handle;
        await op(argv);
    };
})();
