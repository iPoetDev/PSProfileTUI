@{
    ModuleVersion = '1.0.0'
    GUID = '4f6g8h0c-3d5e-6f7g-9h0i-4d5e6f7g8h91'
    Author = 'Charles'
    CompanyName = 'Personal'
    Copyright = '(c) 2024 Charles. All rights reserved.'
    Description = 'Python virtual environment management for PSProfile'
    PowerShellVersion = '5.1'
    
    # Module components
    RootModule = 'VirtualEnv.psm1'
    
    # Functions to export
    FunctionsToExport = @(
        'New-VirtualEnvironment',
        'Enter-VirtualEnvironment',
        'Exit-VirtualEnvironment',
        'Get-VirtualEnvironment'
    )
    
    PrivateData = @{
        PSData = @{
            Tags = @('Python', 'VirtualEnv', 'PSProfile', 'Development')
            ProjectUri = ''
        }
    }
}