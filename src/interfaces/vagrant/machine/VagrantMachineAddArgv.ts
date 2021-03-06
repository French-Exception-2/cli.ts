
interface VagrantMachineAddArgv {
    name:string
    path:string
    type: string
    hostname_pattern: string
    enabled: boolean
    instances: number
    primary: boolean
    vcpus: number
    ip_pattern: string
    ip_start: number
}
