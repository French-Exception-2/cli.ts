(async () => {
    const opModule = require('./../../operations/dns/unmap');

    exports.command = 'dns:unmap';
    exports.desc = 'DNS Unmapping IP/FQDN';
    exports.builder = opModule.builder;
    exports.handler = async function (argv: DnsUnMapArgv) {
        const op = opModule.handle;
        await op(argv);
    };
})();
