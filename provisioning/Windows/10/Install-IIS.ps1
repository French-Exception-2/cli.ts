param(
)

$features = @(
    'IIS-WebServerRole',
    'IIS-WebServer',
    'IIS-CommonHttpFeatures',
    'IIS-HttpErrors',
    'IIS-HttpRedirect',
    'IIS-ApplicationDevelopment',
    'NetFx4Extended-ASPNET45',
    'IIS-NetFxExtensibility45'
    'IIS-HealthAndDiagnostics',
    'IIS-HttpLogging',
    'IIS-LoggingLibraries',
    'IIS-RequestMonitor',
    'IIS-HttpTracing',
    'IIS-Security',
    'IIS-RequestFiltering',
    'IIS-Performance',
    'IIS-WebServerManagementTools',
    'IIS-Metabase',
    'IIS-StaticContent',
    'IIS-DefaultDocument',
    'IIS-WebSockets',
    'IIS-ApplicationInit',
    'IIS-ISAPIExtensions',
    'IIS-ISAPIFilter',
    'IIS-IISCertificateMappingAuthentication',
    'IIS-ClientCertificateMappingAuthentication',
    'IIS-DigestAuthentication',
    'IIS-WindowsAuthentication',
    'IIS-BasicAuthentication',
    'IIS-CertProvider',
    'IIS-ManagementService',
    'IIS-ManagementConsole',
    'IIS-HttpCompressionStatic',
    'IIS-CustomLogging',
    'IIS-ServerSideIncludes',
    'IIS-ASPNET45'
)

foreach ($feature in $features){
    Enable-WindowsOptionalFeature -Online -FeatureName $feature
}

choco install -y urlrewrite