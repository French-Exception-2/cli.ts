(async () => {
    const opModule = require('./../../../operations/docker/context/add');

    exports.command = 'docker:context:add';
    exports.desc = 'Docker add a context';
    exports.builder = opModule.builder;
    exports.handler = async function (argv: DockerContextAddArgv) {
        const op = opModule.handle;
        await op(argv);
    };
})();
