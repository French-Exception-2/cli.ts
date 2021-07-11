interface ConfigSetArgv {
    key:string
    value:any
}

(async () => {
    exports.command = 'config:set';
    exports.desc = 'Set configuration';
    exports.builder = ((process)=>{
        const builder = {
            key: {
                type: 'string',
                required: true
            },
            value: {
                type: 'string',
                required: true
            }
        };

        return builder;
    })(process);
    exports.handler = async function (argv: ConfigSetArgv) {
        throw new Error("not yet implemented");
    };
})();
