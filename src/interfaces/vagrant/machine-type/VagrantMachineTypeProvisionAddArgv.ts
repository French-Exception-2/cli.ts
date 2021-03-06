interface VagrantMachineTypeProvisionAddArgv {
    "machine-name": string;
    name: string;
    path: string;
    enabled: boolean;
    type:string;
    extension:string
    env?:Map<string,string>
    edit:boolean
}