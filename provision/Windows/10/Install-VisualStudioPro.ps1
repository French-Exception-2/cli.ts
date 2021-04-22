param()

choco install -y -f                                         `
    visualstudio2019professional                            `
    visualstudio2019-workload-netcoretools                  `
    visualstudio2019-workload-netweb                        `
    visualstudio2019-workload-netcorebuildtools             `
    visualstudio2019-workload-nodebuildtools                `
    visualstudio2019-workload-manageddesktopbuildtools      `
    visualstudio2019-workload-webbuildtools                 `
    visualstudio2019-workload-vctools                       `
    windows-sdk-10.1                                        `
    netfx-4.8-devpack                                       `
    dotnetcore-runtime.install                              `
    dotnetcore-3.1-windowshosting                           `
    dotnet-windowshosting

Install-Module -Name Invoke-MsBuild -Force
    