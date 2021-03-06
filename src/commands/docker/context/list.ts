(async () => {
    const opModule = require('./../../../operations/docker/context/list');

    exports.command = 'docker:context:list';
    exports.desc = 'Docker list contexts';
    exports.builder = opModule.builder;
    exports.handler = async function (argv: DockerContextListArgv) {
        const op = opModule.handle;
        await op(argv);
    };
})();
