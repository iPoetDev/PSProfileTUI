@{
    # Script module or binary module file associated with this manifest.
    RootModule = 'FeatureMenu.psm1'
    
    # Version number of this module.
    ModuleVersion = '1.0.0'
    
    # ID used to uniquely identify this module
    GUID = '2b3c4d5e-6f7g-8h9i-10j1-k12l13m14n15'
    
    # Author of this module
    Author = 'Charles'
    
    # Company or vendor of this module
    CompanyName = 'Personal'
    
    # Copyright statement for this module
    Copyright = '(c) 2024 Charles. All rights reserved.'
    
    # Description of the functionality provided by this module
    Description = 'Feature Management Menu Module for PSProfile'
    
    # Minimum version of the PowerShell engine required by this module
    PowerShellVersion = '5.1'
    
    # Functions to export from this module
    FunctionsToExport = @(
        'Show-FeatureMenu'
        'Show-ProfileStatus'
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
            Tags = @('Menu', 'Features', 'UI', 'Profile', 'PSProfile')
            
            # A URL to the license for this module.
            LicenseUri = ''
            
            # A URL to the main website for this project.
            ProjectUri = ''
            
            # ReleaseNotes of this module
            ReleaseNotes = 'Initial release of feature menu module'
        }
    }
}
