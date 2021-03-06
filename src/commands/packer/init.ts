(async () => {
    const opModule = require('./../../operations/packer/init');

    exports.command = 'packer:init';
    exports.desc = 'Packer initialize a directory';
    exports.builder = opModule.builder;
    exports.handler = async function (argv: PackerInitArgv) {
        const op = opModule.handle;
        await op(argv);
    };
})();