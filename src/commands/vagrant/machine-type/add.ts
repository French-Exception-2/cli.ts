interface VagrantMachineTypeAddArgv {
  'machine-type-name': string
  vcpus: number
  cpucap: number
  'os-type': string
  'os-version': string
  'ram-mb': number
  'vram-mb': number
  '3d': boolean
  logo: string
  pagefusion: boolean
  gui: boolean
  provider: string
  enabled: boolean
  box: string
  provision: Array<string>
  path: string
  files: Array<string>
}

interface VagrantMachineTypeAddRequest extends VagrantMachineTypeAddArgv {

}

interface VagrantMachineTypeAddResponse extends VagrantMachineTypeAddArgv {

}

(() => {
  exports.command = 'vagrant:machine-type:add <machine-type-name>';
  exports.desc = 'Add new Vagrant Machine Type';
  exports.builder = ((processCwd) => {
    const builder = {
      'machine-type-name': {
        type: 'string',
        required: true,
        description: 'Name of Type'
      },
      'parent-name': {
        type: 'string',
        required: false,
        description: 'Name of Parent Type'
      },
      vcpus: {
        type: 'number',
        required: true,
        description: 'Number of VCPUs'
      },
      cpucap: {
        type: 'number',
        required: true,
        description: 'CPU Cap'
      },
      'os-type': {
        type: 'string',
        required: true,
        description: 'OS Type'
      },
      'os-version': {
        type: 'string',
        required: true,
        description: 'OS Version'
      },
      'ram-mb': {
        type: 'number',
        required: true,
        description: 'RAM in MB'
      },
      'vram-mb': {
        type: 'number',
        required: true,
        description: 'VRAM in MB'
      },
      '3d': {
        type: 'boolean',
        required: true,
        description: '3D'
      },
      logo: {
        type: 'string',
        required: false,
        description: 'Logo image'
      },
      pagefusion: {
        type: 'boolean',
        required: false,
        description: 'PageFusion',
        default: true
      },
      gui: {
        type: 'boolean',
        required: true,
        default: false,
        description: 'GUI'
      },
      provider: {
        type: 'string',
        required: true,
        description: 'VM Provider'
      },
      enabled: {
        type: 'boolean',
        required: true,
        description: 'Enabled',
        default: true
      },
      box: {
        type: 'string',
        required: true,
        description: 'Box name'
      },
      provision: {
        type: 'array',
        default: [],
        description: 'provision'
      },
      path: {
        type: 'string',
        default: processCwd
      },
      files: {
        type: 'array',
        default: []
      }
    };

    return builder;
  })(process.cwd());
  exports.api = async function (request: VagrantMachineTypeAddRequest, response: VagrantMachineTypeAddResponse) {
    const path = require('path');
    const fs = require('fs-extra');
    const _json = require('./../../../Serialization.js');

    const type = {
      vcpus: request.vcpus,
      cpucap: request.cpucap,
      os_type: request['os-type'],
      os_version: request['os-version'],
      ram_mb: request['ram-mb'],
      vram_mb: request['vram-mb'],
      '3d': (request['3d'] ? 'on' : 'off'),
      bioslogoimage: request.logo,
      pagefusion: request.pagefusion,
      gui: request.gui,
      provider: request.provider,
      enabled: request.enabled,
      box: request.box,
      provision: []
    };

    const json_filepath = path.join(request.path, 'config.json');
    let json = JSON.parse(await fs.readFile(json_filepath));

    if (!json['$']['machines-types'])
      json['$']['machines-types'] = {};

    json['$']['machines-types'][request['machine-type-name']] = type;

    await fs.writeFile(json_filepath, _json.toJson(json));

    console.log('vagrant:machine-type:add ' + request['machine-type-name']);

    return response;
  };
  exports.handler = async function (argv: VagrantMachineTypeAddArgv) {
    await exports.api(argv, {});
  };
})();