(async () => {
    const opModule = require('./../../operations/route/list');

    exports.command = 'route:list';
    exports.desc = 'Route list';
    exports.builder = opModule.builder;
    exports.handler = async function (argv: RouteListArgv) {
        const op = opModule.handle;
        await op(argv);
    };
})();
