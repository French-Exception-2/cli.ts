(async () => {
    const opModule = require('./../../../operations/k8s/cluster/list');

    exports.command = 'k8s:cluster:list';
    exports.desc = 'Kubernetes List instances';
    exports.builder = opModule.builder;
    exports.handler = async function (argv: K8sClusterListArgv) {
        const op = opModule.handle;
        await op(argv);
    };
})();
