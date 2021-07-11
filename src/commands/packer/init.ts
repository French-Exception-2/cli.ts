interface PackerInitArgv {
    path: string
    name:string
}

interface PackerInitRequest extends PackerInitArgv {

}

interface PackerInitResponse extends PackerInitArgv {
}

(async () => {
    exports.command = 'packer:init';
    exports.desc = 'Packer init';
    exports.builder = ((processCwd: string) => {
        const builder = {
            name: {
                type: 'string',
                required: true,
                description: 'Name of box'
            },
            path: {
                type: "string",
                default: processCwd,
            }
        };

        return builder;
    })(process.cwd());
    exports.api = async function (request: PackerInitRequest, response:PackerInitResponse) {
        return response;
    };

    exports.handler = async function (argv: PackerInitArgv) {
        await exports.api(argv, {});
    };
})();
