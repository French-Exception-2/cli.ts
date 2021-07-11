import {api, VagrantMachineAddRequest} from "./../../../../src/commands/vagrant/machine/add";

describe('vagrant:machine:add', async function () {

    

    it('can add new machine', async function () {

        const addRequest: VagrantMachineAddRequest = {
            "machine-name": 'dev',
            "machine-type-name": 'dev',
            "hostname-pattern": "",
            "ip-pattern": "",
            "ip-start": 10,
            "ram-mb": 1024,
            enabled: true,
            instances: 2,
            path: '/tmp',
            primary: true,
            vcpus: 1
        };

        const response = await api(addRequest, <any>{});



    });
});