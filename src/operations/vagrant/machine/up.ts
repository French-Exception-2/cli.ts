exports.builder = {
    name: {
        type:'string',
        desc: "Name of Vagrant Machine instance"
    },
    instance: {
        type: 'number',
        desc: 'Instance number',
        default: 0
    }
}

exports.handle = async function(argv:VagrantMachineUpArgv) {

}