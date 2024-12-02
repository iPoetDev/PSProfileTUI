@{
    # Script module or binary module file associated with this manifest.
    RootModule = 'LoadingMenu.psm1'
    
    # Version number of this module.
    ModuleVersion = '1.0.0'
    
    # ID used to uniquely identify this module
    GUID = '1a2b3c4d-5e6f-7g8h-9i10-j11k12l13m14'
    
    # Author of this module
    Author = 'Charles'
    
    # Company or vendor of this module
    CompanyName = 'Personal'
    
    # Copyright statement for this module
    Copyright = '(c) 2024 Charles. All rights reserved.'
    
    # Description of the functionality provided by this module
    Description = 'Profile Loading Menu Module for PSProfile'
    
    # Minimum version of the PowerShell engine required by this module
    PowerShellVersion = '5.1'
    
    # Functions to export from this module
    FunctionsToExport = @(
        'Show-LoadingMenu'
    )
    
    # Cmdlets to export from this module
    CmdletsToExport = @()
    
    # Variables to export from this module
    VariablesToExport = @()
    
    # Aliases to export from this module
    AliasesToExport = @()
    
    # Private data to pass to the module specified in RootModule/ModuleToProcess
    PrivateData = @{
        PSData = @{
            # Tags applied to this module
            Tags = @('Menu', 'UI', 'Profile', 'PSProfile')
            
            # A URL to the license for this module.
            LicenseUri = ''
            
            # A URL to the main website for this project.
            ProjectUri = ''
            
            # ReleaseNotes of this module
            ReleaseNotes = 'Initial release of loading menu module'
        }
    }
}
