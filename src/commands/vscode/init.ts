(() => {

    exports.command = 'vscode:init'
    exports.desc = 'Init .vscode directory'
    exports.builder = {

    }
    exports.handler = function (argv: any) {
        console.log('workspace:new', argv);
    }

})();