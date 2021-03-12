exports.builder = {
    type_name: {
        type: "string",
        description: "Name of VM"
    },
    hostname_pattern: {
        type: "string",
        default: "vdi-#{INSTANCE}-#{NAME}-#{NUMBER}",
    },
    instances: {
        type: "number",
        required: true,
        description: "# Instances",
        default: 1
    },
    enabled: {
        type: "boolean",
        default: true
    },
    primary: {
        type: "boolean",
        default: true
    },
    ip_pattern: {
        type: "string",
        default: "10.100.2.#{NUMBER}"
    },
    ip_start: {
        type: "number",
        default: 10
    },
    ram_mb: {
        type: "number",
        default: 2096
    },
    vcpus: {
        type: "number",
        default: 2
    },
    path: {
        type: "string",
        default: process.cwd(),
    }
}

exports.handle = async function(argv:VagrantMachineSshConfigArgv) {
}