(async () => {
    const opModule = require('./../../operations/route/edit');

    exports.command = 'route:edit';
    exports.desc = 'Route edit';
    exports.builder = opModule.builder;
    exports.handler = async function (argv: RouteEditArgv) {
        const op = opModule.handle;
        await op(argv);
    };
})();
