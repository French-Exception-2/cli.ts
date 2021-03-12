(async () => {
    const opModule = require('./../../operations/route/add');

    exports.command = 'route:add';
    exports.desc = 'Route add';
    exports.builder = opModule.builder;
    exports.handler = async function (argv: RouteAddArgv) {
        const op = opModule.handle;
        await op(argv);
    };
})();
