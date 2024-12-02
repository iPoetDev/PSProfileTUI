@{
    ModuleVersion = '1.0.0'
    GUID = '7c6f8d1a-9e4b-4c5d-8f2e-1a3b4c5d6789'
    Author = 'Charles'
    CompanyName = 'Personal'
    Copyright = '(c) 2024 Charles. All rights reserved.'
    Description = 'Profile initialization module for PSProfile'
    PowerShellVersion = '5.1'
    
    # Module components
    RootModule = 'Initialize.psm1'
    
    # Functions to export
    FunctionsToExport = @(
        'Initialize-PSProfile'
        'Test-ProfileInitialized'
        'Get-ProfileFeatures'
        'Import-ProfileModule'
    )
    
    PrivateData = @{
        PSData = @{
            Tags = @('Initialization', 'Profile', 'Module Loading')
        }
    }
}
