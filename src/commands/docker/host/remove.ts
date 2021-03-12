(async () => {
    const opModule = require("./../../../operations/docker/host/remove");

    exports.command = 'docker:host:remove';
    exports.desc = 'Docker Host remove';
    exports.builder = opModule.builder;
    exports.handler = async function (argv: DockerHostRemoveArgv) {
        const op = opModule.handle;
        await op(argv); 
    };
})();
