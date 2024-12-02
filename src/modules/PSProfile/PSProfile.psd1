@{
    # Script module or binary module file associated with this manifest.
    RootModule = 'PSProfile.psm1'

    # Version number of this module.
    ModuleVersion = '1.0.0'

    # ID used to uniquely identify this module
    GUID = '1d73a601-4a6c-43c5-ba3f-619b18bbb404'

    # Author of this module
    Author = 'Charles Fowler'

    # Company or vendor of this module
    CompanyName = 'IPoetDev'

    # Copyright statement for this module
    Copyright = '(c) 2024 Charles Fowler. All rights reserved.'

    # Description of the functionality provided by this module
    Description = @'
PSProfile is a comprehensive PowerShell profile management system that provides:
- Modular loading system with multiple profile modes (Minimal, Standard, Full)
- Feature management with lazy loading
- Configurable menu system
- Extensive logging and error handling
- Cross-platform compatibility

Key Features:
* Profile Modes: Choose between Minimal, Standard, and Full configurations
* Lazy Loading: Modules are loaded only when needed
* Feature Management: Enable/disable features through an interactive menu
* Extensive Logging: Comprehensive error tracking and debugging
* Cross-Platform: Works on Windows, Linux, and macOS
'@

    # Minimum version of the PowerShell engine required by this module
    PowerShellVersion = '5.1'

    # Modules that must be imported into the global environment prior to importing this module
    RequiredModules = @()

    # Assemblies that must be loaded prior to importing this module
    RequiredAssemblies = @()

    # Script files (.ps1) that are run in the caller's environment prior to importing this module.
    ScriptsToProcess = @()

    # Type files (.ps1xml) to be loaded when importing this module
    TypesToProcess = @()

    # Format files (.ps1xml) to be loaded when importing this module
    FormatsToProcess = @()

    # Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
    NestedModules = @(
        '.\Core\Logging\Logging.psd1'
        '.\Core\Configuration\Configuration.psd1'
        '.\Core\Initialize\Initialize.psd1'
        '.\Features\Git\Git.psd1'
        '.\Features\SSH\SSH.psd1'
        '.\Features\VirtualEnv\VirtualEnv.psd1'
        '.\Features\WSL\WSL.psd1'
        '.\UI\Menu\Menu.psd1'
        '.\UI\Prompt\Prompt.psd1'
    )

    # Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
    FunctionsToExport = @(
        'Initialize-PSProfile'
        'Get-PSProfileConfig'
        'Set-PSProfileConfig'
        'Import-PSProfileModule'
        'Get-PSProfileVersion'
        'Get-PSProfileModules'
        'Select-ProfileMode'
    )

    # Variables to export from this module
    VariablesToExport = @()

    # Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
    AliasesToExport = @()

    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData = @{
        PSData = @{
            # Tags applied to this module. These help with module discovery in online galleries.
            Tags = @(
                'Profile'
                'Configuration'
                'Management'
                'Customization'
                'Git'
                'SSH'
                'WSL'
                'VirtualEnv'
                'Cross-Platform'
                'Windows'
                'Linux'
                'MacOS'
            )

            # A URL to the license for this module.
            LicenseUri = 'https://github.com/ipoetdev/PSProfile/blob/main/LICENSE'

            # A URL to the main website for this project.
            ProjectUri = 'https://github.com/ipoetdev/PSProfile'

            # A URL to an icon representing this module.
            IconUri = ''

            # ReleaseNotes of this module
            ReleaseNotes = @'
# 1.0.0 (2024-01-20)
- Initial release of modular PSProfile system
- Implemented profile modes (Minimal, Standard, Full)
- Added feature management system
- Created interactive menu system
- Added comprehensive logging
- Implemented cross-platform support
'@

            # Prerelease string of this module
            Prerelease = ''

            # Flag to indicate whether the module requires explicit user acceptance for install/update/save
            RequireLicenseAcceptance = $false

            # External dependent modules of this module
            ExternalModuleDependencies = @()
        }
    }

    # HelpInfo URI of this module
    HelpInfoURI = 'https://github.com/ipoetdev/PSProfile/wiki'

    # Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
    DefaultCommandPrefix = ''
}
