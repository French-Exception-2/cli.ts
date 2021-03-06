
exports.builder = {
    name: {
        type: "string",
        required: true,
        description: "Name of Type"
      },
      vcpus: {
        type: "number",
        required: true,
        description: "Number of VCPUs"
      },
      cpucap: {
        type: "number",
        required: true,
        description: "CPU Cap"
      },
      os_type: {
        type: "string",
        required: true,
        description: "OS Type"
      },
      os_version: {
        type: "string",
        required: true,
        description: "OS Version"
      },
      ram_mb: {
        type: "number",
        required: true,
        description: "RAM in MB"
      },
      vram_mb: {
        type: "number",
        required: true,
        description: "VRAM in MB"
      },
      "3d": {
        type: "boolean",
        required: true,
        description: "3D"
      },
      logo: {
        type: "string",
        required: false,
        description: "Logo image"
      },
      pagefusion: {
        type: "boolean",
        required: false,
        description: "PageFusion",
        default: true
      },
      gui: {
        type: "boolean",
        required: true,
        default: false,
        description: "GUI"
      },
      provider: {
        type: "string",
        required: true,
        description: "VM Provider"
      },
      enabled: {
        type: "boolean",
        required: true,
        description: "Enabled",
        default: true
      },
      box: {
        type: "string",
        required: true,
        description: "Box name"
      },
      provisioning: {
        type: "array",
        default: [],
        description: "Provisioning"
      },
      path: {
        type: "string",
        default: process.cwd()
      },
      files: {
        type: 'array',
        default: []
      }
}
exports.handle = async function(argv:VsCodeInitArgv) {
    
}