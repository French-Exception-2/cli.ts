(async () => {
    const opModule = require('./../../../operations/k8s/cluster/init');

    exports.command = 'k8s:cluster:init';
    exports.desc = 'Kubernetes Init new instance';
    exports.builder = opModule.builder;
    exports.handler = async function (argv: K8sClusterInitArgv) {
        const op = opModule.handle;
        await op(argv);
    };
})();
