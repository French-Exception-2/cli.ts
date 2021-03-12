(async () => {
    const opModule = require('./../../../operations/k8s/cluster/add');

    exports.command = 'k8s:cluster:add';
    exports.desc = 'Kubernetes Cluster add an existing instance';
    exports.builder = opModule.builder;
    exports.handler = async function (argv: K8sClusterAddArgv) {
        const op = opModule.handle;
        await op(argv);
    };
})();
