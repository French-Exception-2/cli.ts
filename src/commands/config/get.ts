interface ConfigGetArgv {
    key: string
    raw: boolean
    path:string
}

(async () => {
    exports.command = 'config:get';
    exports.desc = 'Get configuration';
    exports.builder = ((process:any) => {
        
    })(process);
    exports.handler = async function (argv: ConfigGetArgv) {
        const config = require(require('path').join(__dirname, 'load'));
        const loaded = await config.load(argv.path);
        const get = await loaded.get(argv.key);

        if(Array.isArray(get)) {
            // todo console log table
            console.log(get);
        } else {
            const str = JSON.stringify(get, null, 2);
            console.log(str);
        }
    };
})();
