(async () => {
    const opModule = require('./../../../operations/k8s/endpoint/add');

    exports.command = 'k8s:endpoint:add';
    exports.desc = 'Kubernetes Add endpoint';
    exports.builder = opModule.builder;
    exports.handler = async function (argv: K8sEndpointAddArgv) {
        const op = opModule.handle;
        await op(argv);
    };
})();
