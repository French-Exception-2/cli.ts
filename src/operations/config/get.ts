module.exports = {
    builder: {
        raw: {
            type: 'boolean',
            default: false
        },
        key: {
            type: 'string',
            required: true
        },
        path: {
            type: "string",
            default: process.cwd(),
        }
    },
    handle: async function (argv: ConfigGetArgv) {
        const config = require('./load');

        const loaded = await config.load(argv.path);

        const get = await loaded.get(argv.key);

        if(Array.isArray(get)) {
            // console log table
            console.log(get);
        } else {
            const str = JSON.stringify(get, null, 2);

            console.log(str);
        }
        
    }
}