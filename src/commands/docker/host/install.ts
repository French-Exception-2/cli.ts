(async () => {
    const opModule = require("./../../../operations/docker/host/install");

    exports.command = 'docker:host:install';
    exports.desc = 'Docker Host install';
    exports.builder = opModule.builder;
    exports.handler = async function (argv: DockerHostInstallArgv) {
        const op = opModule.handle;
        await op(argv);
    };
})();
