(async () => {
    const opModule = require('./../../operations/route/remove');

    exports.command = 'route:remove';
    exports.desc = 'Route remove';
    exports.builder = opModule.builder;
    exports.handler = async function (argv: RouteRemoveArgv) {
        const op = opModule.handle;
        await op(argv);
    };
})();
