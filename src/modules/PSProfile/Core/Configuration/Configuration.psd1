@{
    ModuleVersion = '1.0.0'
    GUID = '9e2f5d3a-8b4c-4e97-a3f6-2c8d0e6a5678'
    Author = 'Charles'
    CompanyName = 'Personal'
    Copyright = '(c) 2024 Charles. All rights reserved.'
    Description = 'Configuration management module for PSProfile'
    PowerShellVersion = '5.1'
    
    # Module components
    RootModule = 'Configuration.psm1'
    
    # Functions to export
    FunctionsToExport = @(
        'Get-PSProfileConfig'
        'Set-PSProfileConfig'
        'Reset-PSProfileConfig'
        'Export-PSProfileConfig'
        'Import-PSProfileConfig'
    )
    
    PrivateData = @{
        PSData = @{
            Tags = @('Configuration', 'Settings', 'Profile Management')
        }
    }
}
