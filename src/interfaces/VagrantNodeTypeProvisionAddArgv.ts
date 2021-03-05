interface VagrantNodeTypeProvisionAddArgv {
    "machine-name": string;
    name: string;
    path: string;
    enabled: boolean;
    type:string;
    extension:string
    env?:Map<string,string>
}