interface ConfigDumpCommandArgv {
    raw: boolean
    path: string
}

interface ConfigDumpRequest extends ConfigDumpCommandArgv {

}

interface ConfigDumpResponse extends ConfigDumpCommandArgv {
    dump: object
}

(async () => {
    exports.command = 'config:dump';
    exports.desc = 'Dump configuration';
    exports.builder = ((processCwd: string) => {
        const builder = {
            raw: {
                type: 'boolean',
                default: false
            },
            path: {
                type: "string",
                default: processCwd,
            }
        };

        return builder;
    })(process.cwd());
    exports.api = async function (request: ConfigDumpRequest, response: ConfigDumpResponse) {
        const config = require(require('path').join(__dirname, 'load'));
        const loaded = await config.load(request.path);
        response.dump = await loaded.dump();
        return response;
    };

    exports.handler = async function (argv: ConfigDumpCommandArgv) {
        const response = await exports.api(argv, {});
        console.log(JSON.stringify(response.dump, null, 2));
    };
})();
