(async () => {
    const opModule = require('./../../operations/dns/map');

    exports.command = 'dns:map';
    exports.desc = 'DNS Mapping IP/FQDN';
    exports.builder = opModule.builder;
    exports.handler = async function (argv: DnsMapArgv) {
        const op = opModule.handle;
        await op(argv);
    };
})();
