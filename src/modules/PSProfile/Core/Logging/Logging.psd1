@{
    ModuleVersion = '1.0.0'
    GUID = '8d1f4e2b-7a3c-4d96-b8e5-3f2d9c5a1234'
    Author = 'Charles'
    CompanyName = 'Personal'
    Copyright = '(c) 2024 Charles. All rights reserved.'
    Description = 'Logging module for PSProfile'
    PowerShellVersion = '5.1'
    
    # Module components
    RootModule = 'Logging.psm1'
    
    # Functions to export
    FunctionsToExport = @(
        'Write-ErrorLog'
        'Write-PerformanceLog'
        'Initialize-LogDirectory'
    )
    
    PrivateData = @{
        PSData = @{
            Tags = @('Logging', 'Error Handling', 'Performance')
        }
    }
}
