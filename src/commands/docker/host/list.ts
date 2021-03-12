(async () => {
    const opModule = require("./../../../operations/docker/host/list");

    exports.command = 'docker:host:list';
    exports.desc = 'docker Host list';
    exports.builder = opModule.builder;
    exports.handler = async function (argv: DockerHostListArgv) {
        const op = opModule.handle;
        await op(argv);
    };
})();
