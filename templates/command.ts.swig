(async () => {
    const opModule = require("./../../../operations/{{ $commandPath }}");

    exports.command = '{{ command }}';
    exports.desc = '{{ desc }}';
    exports.builder = opModule.builder;
    exports.handler = async function (argv: {{ argvTypeInterface }}) {
        const op = opModule.handle;
        await op(argv);
    };
})();
