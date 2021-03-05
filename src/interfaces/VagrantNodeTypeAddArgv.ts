interface VagrantNodeTypeAddArgv {
    vcpus: number
    cpucap: number
    os_type: string
    os_version: string
    ram_mb: number
    vram_mb: number
    "3d": boolean
    bioslogoimage: string
    pagefusion: boolean
    gui: boolean
    provider: string
    enabled: boolean
    box: string
    provisioning: Array<string>
    path: string
    name: string
}