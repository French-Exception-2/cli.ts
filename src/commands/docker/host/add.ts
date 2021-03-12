(async () => {
    const opModule = require("./../../../operations/docker/host/add");

    exports.command = 'docker:host:add';
    exports.desc = 'docker Host add';
    exports.builder = opModule.builder;
    exports.handler = async function (argv: DockerHostAddArgv) {
        const op = opModule.handle;
        await op(argv);
    };
})();
