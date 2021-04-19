interface ConfigDumpCommandArgv {
    raw: boolean
    path: string
}

(async () => {
    exports.command = 'config:dump';
    exports.desc = 'Dump configuration';
    exports.builder = ((process: any) => {
        const builder = {
            raw: {
                type: 'boolean',
                default: false
            },
            path: {
                type: "string",
                default: process.cwd(),
            }
        };

        return builder;
    })(process);
    exports.handler = async function (argv: ConfigDumpCommandArgv) {
        const config = require(require('path').join(__dirname, 'load'));
        const loaded = await config.load(argv.path);
        const dumped = await loaded.dump();
        console.log(JSON.stringify(dumped, null, 2));
    };
})();
